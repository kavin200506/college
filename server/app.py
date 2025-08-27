from fastapi import FastAPI
from pydantic import BaseModel
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch, json

tokenizer = AutoTokenizer.from_pretrained("deepseek-ai/DeepSeek-V3.1", trust_remote_code=True)
model     = AutoModelForCausalLM.from_pretrained(
    "deepseek-ai/DeepSeek-V3.1",
    torch_dtype=torch.bfloat16,
    device_map="auto",
    trust_remote_code=True,
)

api = FastAPI()

class Message(BaseModel):
    role: str  # 'user' | 'assistant' | 'system'
    content: str

class ChatRequest(BaseModel):
    messages: list[Message]
    max_tokens: int = 512
    temperature: float = 0.8
    thinking: bool = False          # choose the chat template

@api.post("/chat")
def chat(req: ChatRequest):
    tpl = {"thinking": req.thinking, "add_generation_prompt": True}
    prompt = tokenizer.apply_chat_template(
        [m.model_dump() for m in req.messages],
        **tpl,
        tokenize=False,
    )
    input_ids = tokenizer.encode(prompt, return_tensors="pt").to(model.device)
    out = model.generate(
        input_ids,
        max_new_tokens=req.max_tokens,
        temperature=req.temperature,
        eos_token_id=tokenizer.eos_token_id,
    )
    answer = tokenizer.decode(out[0][input_ids.shape[-1]:], skip_special_tokens=True)
    return {"reply": answer.strip()}
