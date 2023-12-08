Return-Path: <ceph-devel+bounces-266-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AEE9180A570
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 15:28:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 620731F21323
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 14:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF7CD1DFE1;
	Fri,  8 Dec 2023 14:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UXHLjeWS"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDCF1738
	for <ceph-devel@vger.kernel.org>; Fri,  8 Dec 2023 06:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702045680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eTSw2QQlmLpT6T9JCXxqMR9ycRkOeHrH93C8GaRsuA4=;
	b=UXHLjeWSq5/APKRDPweMMbEnB5bHHq5SutDAHjxSuaSgdFQoWv+AwiFtBJb0wIlXmN+Tl8
	LWZPJ4s65j+0e2aDEUBvE928oycLF0MDPqc/kHaa9f9L1eAhS6y2jrq1wJeadwxCfA8YMG
	rrNiZOSQcd9WNwcHeEg/rrTjxIJsUGg=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-CivGMyqZNQWSQv6pyCypkA-1; Fri, 08 Dec 2023 09:27:58 -0500
X-MC-Unique: CivGMyqZNQWSQv6pyCypkA-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1d0a0ee3112so20693415ad.3
        for <ceph-devel@vger.kernel.org>; Fri, 08 Dec 2023 06:27:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702045677; x=1702650477;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eTSw2QQlmLpT6T9JCXxqMR9ycRkOeHrH93C8GaRsuA4=;
        b=jvlYpe5xI2cVjwW3mEEckOKJWKe92Y7TMytQriteBEWX8nL+J0Xm89IBB3goeQcBGF
         hzV+Utlyg8ERggISiJZPGw6uBmjy4xqYZWE/vLPllbRgWYEF9WkxIC83QTroGj0fQZgb
         sVEmMKtdW/rS1IaulOAMfa/KtLbe38WEnZCjNI7O1MvDy+WxhYDsJp/yFDVBVhqaKeuv
         bFck4yvwIsqAH7RYSYNBcUYursEIPBig8RoYkcmjjrfEb48jjWoZkb/06oA+jx8gyksO
         ekAGuay1xkdkOXRprpYcu/DdLW/MYuaylAk2tsfVQih4XvtrlU8kE7I+cRcCzF+Fj1x7
         Uwyg==
X-Gm-Message-State: AOJu0Yxu2b7okaDOVc6fW5QUMIw9HjF5HQZCgZ1LNYGdBrb5oVrfyoaz
	Dz8qMPUKhpUBFvbdY9DKuQmkApj1q/UpZsrNQ/1MB7NdzYHJYIVhXOpBjnMNhMwEFw69edfoGad
	n6ftBr3q1jq65pLcVmFtIfA==
X-Received: by 2002:a17:902:f549:b0:1d0:708c:d04b with SMTP id h9-20020a170902f54900b001d0708cd04bmr143921plf.31.1702045677245;
        Fri, 08 Dec 2023 06:27:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEiwd3WtboYR6VItA/WxECWCN7IR+381onblgFeRsIyuobSRZXk41HD/40RZlFiI79JszfIhw==
X-Received: by 2002:a17:902:f549:b0:1d0:708c:d04b with SMTP id h9-20020a170902f54900b001d0708cd04bmr143907plf.31.1702045676936;
        Fri, 08 Dec 2023 06:27:56 -0800 (PST)
Received: from [10.72.112.27] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w18-20020a170902e89200b001d051725d09sm1754252plg.241.2023.12.08.06.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Dec 2023 06:27:56 -0800 (PST)
Message-ID: <8358beb6-227c-420a-b66a-fe6c483471af@redhat.com>
Date: Fri, 8 Dec 2023 22:27:52 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] libceph: just wait for more data to be available on
 the socket
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com
References: <20231208043305.91249-1-xiubli@redhat.com>
 <20231208043305.91249-3-xiubli@redhat.com>
 <CAOi1vP-RT6zu6ed+-LVrCGZ+a=Yi1zakyqaLkHMcE=LVQkZiTQ@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-RT6zu6ed+-LVrCGZ+a=Yi1zakyqaLkHMcE=LVQkZiTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/8/23 19:58, Ilya Dryomov wrote:
> On Fri, Dec 8, 2023 at 5:34 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The messages from ceph maybe split into multiple socket packages
>> and we just need to wait for all the data to be availiable on the
>> sokcet.
>>
>> URL: https://tracker.ceph.com/issues/63586
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   net/ceph/messenger_v1.c | 18 ++++++++++--------
>>   1 file changed, 10 insertions(+), 8 deletions(-)
>>
>> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
>> index f9a50d7f0d20..aff81fef932f 100644
>> --- a/net/ceph/messenger_v1.c
>> +++ b/net/ceph/messenger_v1.c
>> @@ -1160,15 +1160,17 @@ static int read_partial_message(struct ceph_connection *con)
>>          /* header */
>>          size = sizeof(con->v1.in_hdr);
>>          end = size;
>> -       ret = read_partial(con, end, size, &con->v1.in_hdr);
>> -       if (ret <= 0)
>> -               return ret;
>> +       if (con->v1.in_base_pos < end) {
>> +               ret = read_partial(con, end, size, &con->v1.in_hdr);
>> +               if (ret <= 0)
>> +                       return ret;
>>
>> -       crc = crc32c(0, &con->v1.in_hdr, offsetof(struct ceph_msg_header, crc));
>> -       if (cpu_to_le32(crc) != con->v1.in_hdr.crc) {
>> -               pr_err("read_partial_message bad hdr crc %u != expected %u\n",
>> -                      crc, con->v1.in_hdr.crc);
>> -               return -EBADMSG;
>> +               crc = crc32c(0, &con->v1.in_hdr, offsetof(struct ceph_msg_header, crc));
>> +               if (cpu_to_le32(crc) != con->v1.in_hdr.crc) {
>> +                       pr_err("read_partial_message bad hdr crc %u != expected %u\n",
>> +                              crc, con->v1.in_hdr.crc);
>> +                       return -EBADMSG;
>> +               }
>>          }
>>
>>          front_len = le32_to_cpu(con->v1.in_hdr.front_len);
>> --
>> 2.43.0
>>
> Hi Xiubo,
>
> This doesn't seem right to me.  read_partial() is supposed to be called
> unconditionally.  On a short read (i.e. when it's unable to fill the
> destination buffer -- in this case the header), it returns 0 and the
> stack is supposed to unroll all the way up to ceph_con_workfn().
>
> If the destination buffer is already filled, read_partial() does
> nothing and returns 1.  Recomputing the header crc in case
> read_partial_message() is called repeatedly shouldn't be an issue
> because con->v1.in_hdr shouldn't be modified in the interim.  If it
> gets modified, it's a bug.
>
> It might help if you provide a step-by-step breakdown of the scenario
> that you are trying to address in the commit message.

Yeah, you are correct.

So my first change was correct, I just adjust the patch before sending 
it out.

Let me change it back.

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>


