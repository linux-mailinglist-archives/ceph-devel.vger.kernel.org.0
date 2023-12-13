Return-Path: <ceph-devel+bounces-278-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D18E5810773
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Dec 2023 02:13:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C5562821B9
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Dec 2023 01:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43448A5E;
	Wed, 13 Dec 2023 01:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X78w+Pkt"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896C091
	for <ceph-devel@vger.kernel.org>; Tue, 12 Dec 2023 17:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702429989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FPwVuWjlL4qKdRy2/72r++qWHVFS3wBBA0KdE8+nJwY=;
	b=X78w+PktNAoXvbsZOEcD3YPdC/U3yCFg5R5RV7hThOQi8vj0Xnc+evsFLWAnTb96DYVnD9
	BB8X3fCcmeQzCEUcMA0Edjxx0jIE/MwbVeO0/Q4XfJgFYgToQ8rSTuZJM1XVxoH002crmj
	3OPvQBSr5cRSl6rGdE/vkq36o/X8ck0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-Bd98bQcqP3mPgxiQSIJpkA-1; Tue, 12 Dec 2023 20:13:08 -0500
X-MC-Unique: Bd98bQcqP3mPgxiQSIJpkA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1d043878cadso36592495ad.3
        for <ceph-devel@vger.kernel.org>; Tue, 12 Dec 2023 17:13:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702429987; x=1703034787;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FPwVuWjlL4qKdRy2/72r++qWHVFS3wBBA0KdE8+nJwY=;
        b=egedZxm7fPuI5fwko5bVTHkfhQvemHQh75TY9IVGxZANmQ4rPpmf7BE9c6tw6/K//b
         ayFY1C84s4bQ4cAHVvmwJvv82ckO9yyGJihgf+6BVHP/vLL15BPbBkdtaa3KXYFNhBF8
         B8nq6WVXYzeGNzXjWwSwNvhhD0lu/yWVIJC64m5b1VZ6oDZuLRJ+IaMA5Enra6ZWW5/l
         hr1arK6bDqjbL77yEdIiU+x9ZcdQJOl1swaiL5CgbS/0B0rYNBpFtvDTFhA0fNefe5XR
         wRPLgdMrUaH1AOyyR1AR32xhAlBJLmir5Q2Z1Jmdg/Mn6ofqv6T/Smc+eCLizO/tADIb
         4jhg==
X-Gm-Message-State: AOJu0Yy72OU7sGoMtXdBHAXUGk9PxGPGJgvTKMJydsZV1a6aisMU0bzM
	3WniBDwL4Prlyi4tkfX7PSM4yt04E2RAb94GECxPeblUHrsTclPcRbuND1scIC7ya/kmcWlHWfn
	PQiIKtTAt/LkkJ/YUnjKItA==
X-Received: by 2002:a17:902:da85:b0:1d0:6ffd:f201 with SMTP id j5-20020a170902da8500b001d06ffdf201mr4239409plx.87.1702429986995;
        Tue, 12 Dec 2023 17:13:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGNecQpEGgqoqcZEDI0T4g2S7SBMs3QMOjQvCqApJlwGcB2vwX0z9r9lereu8xDRy9Jcq/q8g==
X-Received: by 2002:a17:902:da85:b0:1d0:6ffd:f201 with SMTP id j5-20020a170902da8500b001d06ffdf201mr4239399plx.87.1702429986653;
        Tue, 12 Dec 2023 17:13:06 -0800 (PST)
Received: from [10.72.113.27] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902ed0d00b001d078445059sm9274571pld.143.2023.12.12.17.13.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Dec 2023 17:13:06 -0800 (PST)
Message-ID: <9c058f59-4f16-4aab-ba29-abb3c2133db3@redhat.com>
Date: Wed, 13 Dec 2023 09:13:02 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] libceph: just wait for more data to be available
 on the socket
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com
References: <20231208160601.124892-1-xiubli@redhat.com>
 <20231208160601.124892-3-xiubli@redhat.com>
 <CAOi1vP8ft0nFh2qdQDRpGr7gPCj3HHDzY4Q7i69WQLiASPxNyw@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP8ft0nFh2qdQDRpGr7gPCj3HHDzY4Q7i69WQLiASPxNyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Ilya,

I just fixed it and it will be something like this below, I haven't 
tested it yet because I am running other tests locally.

This time it will set the state to 'CEPH_SPARSE_READ_FINISH' when the 
last sparse-read op is successfully read.

diff --git a/include/linux/ceph/osd_client.h 
b/include/linux/ceph/osd_client.h
index 493de3496cd3..00d98e13100f 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -47,6 +47,7 @@ enum ceph_sparse_read_state {
         CEPH_SPARSE_READ_DATA_LEN,
         CEPH_SPARSE_READ_DATA_PRE,
         CEPH_SPARSE_READ_DATA,
+       CEPH_SPARSE_READ_FINISH,
  };

  /*
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 848ef19055a0..b3b61f010428 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5813,6 +5813,7 @@ static int prep_next_sparse_read(struct 
ceph_connection *con,

         /* reset for next sparse read request */
         spin_unlock(&o->o_requests_lock);
+       sr->sr_state = CEPH_SPARSE_READ_FINISH;
         o->o_sparse_op_idx = -1;
         return 0;
  found:
@@ -5918,8 +5919,6 @@ static int osd_sparse_read(struct ceph_connection 
*con,
                                                     count);
                                 return -EREMOTEIO;
                         }
-
-                       sr->sr_state = CEPH_SPARSE_READ_HDR;
                         goto next_op;
                 }

@@ -5952,6 +5951,8 @@ static int osd_sparse_read(struct ceph_connection 
*con,
                 /* Bump the array index */
                 ++sr->sr_index;
                 break;
+       case CEPH_SPARSE_READ_FINISH:
+               return 0;
         }
         return ret;
  }

I will send out the V3 after my testing.


Jeff,

Could you help review it, want to make sure that it won't break anything 
here for sparse read.


Thanks

- Xiubo


On 12/13/23 00:31, Ilya Dryomov wrote:
> On Fri, Dec 8, 2023 at 5:08 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The messages from ceph maybe split into multiple socket packages
>> and we just need to wait for all the data to be availiable on the
>> sokcet.
>>
>> This will add a new _FINISH state for the sparse-read to mark the
>> current sparse-read succeeded. Else it will treat it as a new
>> sparse-read when the socket receives the last piece of the osd
>> request reply message, and the cancel_request() later will help
>> init the sparse-read context.
>>
>> URL: https://tracker.ceph.com/issues/63586
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   include/linux/ceph/osd_client.h | 1 +
>>   net/ceph/osd_client.c           | 6 +++---
>>   2 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
>> index 493de3496cd3..00d98e13100f 100644
>> --- a/include/linux/ceph/osd_client.h
>> +++ b/include/linux/ceph/osd_client.h
>> @@ -47,6 +47,7 @@ enum ceph_sparse_read_state {
>>          CEPH_SPARSE_READ_DATA_LEN,
>>          CEPH_SPARSE_READ_DATA_PRE,
>>          CEPH_SPARSE_READ_DATA,
>> +       CEPH_SPARSE_READ_FINISH,
>>   };
>>
>>   /*
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 848ef19055a0..f1705b4f19eb 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -5802,8 +5802,6 @@ static int prep_next_sparse_read(struct ceph_connection *con,
>>                          advance_cursor(cursor, sr->sr_req_len - end, false);
>>          }
>>
>> -       ceph_init_sparse_read(sr);
>> -
>>          /* find next op in this request (if any) */
>>          while (++o->o_sparse_op_idx < req->r_num_ops) {
>>                  op = &req->r_ops[o->o_sparse_op_idx];
>> @@ -5919,7 +5917,7 @@ static int osd_sparse_read(struct ceph_connection *con,
>>                                  return -EREMOTEIO;
>>                          }
>>
>> -                       sr->sr_state = CEPH_SPARSE_READ_HDR;
>> +                       sr->sr_state = CEPH_SPARSE_READ_FINISH;
>>                          goto next_op;
> Hi Xiubo,
>
> This code appears to be set up to handle multiple (sparse-read) ops in
> a single OSD request.  Wouldn't this break that case?
>
> I think the bug is in read_sparse_msg_data().  It shouldn't be calling
> con->ops->sparse_read() after the message has progressed to the footer.
> osd_sparse_read() is most likely fine as is.
>
> Notice how read_partial_msg_data() and read_partial_msg_data_bounce()
> behave: if called at that point (i.e. after the data section has been
> processed, meaning that cursor->total_resid == 0), they do nothing.
> read_sparse_msg_data() should have a similar condition and basically
> no-op itself.
>
> While at it, let's rename it to read_partial_sparse_msg_data() to
> emphasize the "partial"/no-op semantics that are required there.
>
> Thanks,
>
>                  Ilya
>


