Return-Path: <ceph-devel+bounces-24-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B06957DDA1F
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Nov 2023 01:40:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6532A281853
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Nov 2023 00:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 755BA62B;
	Wed,  1 Nov 2023 00:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g7nFxdSO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2971D36B
	for <ceph-devel@vger.kernel.org>; Wed,  1 Nov 2023 00:40:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB27F3
	for <ceph-devel@vger.kernel.org>; Tue, 31 Oct 2023 17:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698799226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Om16SAVvSoElydsHeL1My2ml/gFc4DewMeJibBJf2Kk=;
	b=g7nFxdSOH0yV/bJ2iuj29yfYfYvgpExUlGyc4Ha98VJnZjJZVMbBEW2+42EMq0+ZcUwSQB
	LP8FDXhMc2xN5veXbA5TEAu6hPCHhx0Zcnjjf0juiGgU6dtKcZtem4B5cNIUQtKgXY/47U
	QliwVMpHfkO7/zZTVY6xuRKYmGCIkrE=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-nw0aEawxOvqFQXuoRZeWAg-1; Tue, 31 Oct 2023 20:40:25 -0400
X-MC-Unique: nw0aEawxOvqFQXuoRZeWAg-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-58b57d05c70so4317979a12.1
        for <ceph-devel@vger.kernel.org>; Tue, 31 Oct 2023 17:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698799224; x=1699404024;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Om16SAVvSoElydsHeL1My2ml/gFc4DewMeJibBJf2Kk=;
        b=Bk0axrKTSLFmCXMxeQPIjATPh9o8qF+9SP9y/veM/OEcE67w2J8iGMjQABeaLavY0i
         qO7J+2MZRB+j1RlCwzyqy/K41OUSKihOahEMnW+WcumMe7qid9Xizqt22+ZXHSn1W6lM
         cilKfp3A1pgPSeIkKu2KcaYfW+to4Kkr3bas1BXcHhSrFqxvFYHlrOzZ+Kl+JktgntBA
         E8dqunFgKZyvfG5z/x9oVEkRNCqQB3HntSZ6P3rII8XyZPdtDkw5xuAt2KxbniqILmwh
         V1jc5iYwYUpnR0Q4UZfjjrKvAsQ9SDAa0QQacAshcOM+AQmVt+VEfmTyQC/yW4TDPcpk
         RRaA==
X-Gm-Message-State: AOJu0YzEvohCDKPtVngwQ+jPwgtQzC95y6pwrL0ciT4HWd6a395ddSFD
	JhDWdhLnFNWRebIbiDikbGitfCvmZyqrAho3e18hZvFw9Dj9lrReokADdmg7QgDN18CFD0N3E7w
	Mdfry6hNA7Y+0mULynVwp4w==
X-Received: by 2002:a05:6a20:e10c:b0:14c:c9f6:d657 with SMTP id kr12-20020a056a20e10c00b0014cc9f6d657mr14566257pzb.22.1698799224239;
        Tue, 31 Oct 2023 17:40:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGStmlO0TIyTvVc9Fudame7sgqiqbX+9LpqsoV4AFJav0cA/s8xb/nlfscVuiYjLsLvuNfrNw==
X-Received: by 2002:a05:6a20:e10c:b0:14c:c9f6:d657 with SMTP id kr12-20020a056a20e10c00b0014cc9f6d657mr14566246pzb.22.1698799223879;
        Tue, 31 Oct 2023 17:40:23 -0700 (PDT)
Received: from [10.72.112.128] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 14-20020a17090a018e00b0026b3f76a063sm1768021pjc.44.2023.10.31.17.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Oct 2023 17:40:23 -0700 (PDT)
Message-ID: <c6235972-8641-c5b1-d217-2fe7be206e20@redhat.com>
Date: Wed, 1 Nov 2023 08:40:19 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/3] libceph: do not decrease the data length more than
 once
To: Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com
References: <20231024050039.231143-1-xiubli@redhat.com>
 <20231024050039.231143-2-xiubli@redhat.com>
 <832919f25c9f923e5f908d18a3581375d02342ef.camel@kernel.org>
 <cc4eb9db0d65d324bb658ef4a40f6715653d75aa.camel@kernel.org>
 <5562bc72-679c-46e8-1d6c-f31782479649@redhat.com>
 <9ed3a4a7a481f1d40661a717d0f6110558b29f7f.camel@kernel.org>
 <a333ae58-1133-1030-f4d2-007d6297fe55@redhat.com>
 <13f48356b57fae1289776d2f4f84218a845e7c27.camel@kernel.org>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <13f48356b57fae1289776d2f4f84218a845e7c27.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 10/31/23 18:17, Jeff Layton wrote:
> On Tue, 2023-10-31 at 10:04 +0800, Xiubo Li wrote:
>> On 10/31/23 08:23, Jeff Layton wrote:
>>> On Tue, 2023-10-31 at 08:17 +0800, Xiubo Li wrote:
>>>> On 10/30/23 20:30, Jeff Layton wrote:
>>>>> On Mon, 2023-10-30 at 06:21 -0400, Jeff Layton wrote:
>>>>>> On Tue, 2023-10-24 at 13:00 +0800, xiubli@redhat.com wrote:
>>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>>
>>>>>>> No need to decrease the data length again if we need to read the
>>>>>>> left data.
>>>>>>>
>>>>>>> URL: https://tracker.ceph.com/issues/62081
>>>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>>>> ---
>>>>>>>     net/ceph/messenger_v2.c | 1 -
>>>>>>>     1 file changed, 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
>>>>>>> index d09a39ff2cf0..9e3f95d5e425 100644
>>>>>>> --- a/net/ceph/messenger_v2.c
>>>>>>> +++ b/net/ceph/messenger_v2.c
>>>>>>> @@ -1966,7 +1966,6 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
>>>>>>>     				bv.bv_offset = 0;
>>>>>>>     			}
>>>>>>>     			set_in_bvec(con, &bv);
>>>>>>> -			con->v2.data_len_remain -= bv.bv_len;
>>>>>>>     			return 0;
>>>>>>>     		}
>>>>>>>     	} else if (iov_iter_is_kvec(&con->v2.in_iter)) {
>>>>>> It's been a while since I was in this code, but where does this get
>>>>>> decremented if you're removing it here?
>>>>>>
>>>>> My question was a bit vague, so let me elaborate a bit:
>>>>>
>>>>> data_len_remain should be how much unconsumed data is in the message
>>>>> (IIRC). As we call prepare_sparse_read_cont multiple times, we're
>>>>> consuming the message data and this gets decremented as we go.
>>>>>
>>>>> In the above case, we're consuming the message data into the bvec, so
>>>>> why shouldn't we be decrementing the remaining data by that amount?
>>>> Hi Jeff,
>>>>
>>>> If I didn't miss something about this. IMO we have already decreased it
>>>> in the following two cases:
>>>>
>>>> [1]
>>>> https://github.com/ceph/ceph-client/blob/for-linus/net/ceph/messenger_v2.c#L2000
>>>>
>>>> [2]
>>>> https://github.com/ceph/ceph-client/blob/for-linus/net/ceph/messenger_v2.c#L2025
>>>>
>>>> And here won't we decrease them twice ?
>>>>
>>>>
>>> I don't get it. The functions returns in both of those cases just after
>>> decrementing data_len_remain, so how can it have already decremented it?
>>>
>>> Maybe I don't understand the bug you're trying to fix. data_len_remain
>>> only comes into play when we need to revert. Does the problem involve a
>>> trip through revoke_at_prepare_sparse_data()?
>> Such as for the first time to read the data it will trigger:
>>
>> prepare_sparse_read_cont()
>>
>>     --> ret = con->ops->sparse_read()
>>          --> cursor->sr_resid = elen;
>>
>>
>>     --> if (buf) {con->v2.data_len_remain -= ret;}   // After calling
>> ->sparse_read() it will decrease 'ret', which is 'elen'.
>>
>> Then the msg will try to read data from the socket buffer, and if the
>> data read is less than expected 'elen' then it will go to the code:
>>
>> https://github.com/ceph/ceph-client/blob/for-linus/net/ceph/messenger_v2.c#L1960-L1971
>>
>> And then won't it decrease 'data_len_remain' twice ?
>>
>> Did I misreading it the sparse read state machine ?
>>
>
> Here's the full snippet of code around that area. In this code, we've
> just received the data from "in" iter into the current bvec and have
> either copied it from the bounce buffer or done the CRC for the last
> bvec. Now, we're advancing the iter by the amount we've just read, and
> reducing the sr_resid value (which is the residual data in the  current
> extent):
>
>                  ceph_msg_data_advance(cursor, con->v2.in_bvec.bv_len);
>                  cursor->sr_resid -= con->v2.in_bvec.bv_len;
>                  dout("%s: advance by 0x%x sr_resid 0x%x\n", __func__,
>                       con->v2.in_bvec.bv_len, cursor->sr_resid);
>                  WARN_ON_ONCE(cursor->sr_resid > cursor->total_resid);
>                  if (cursor->sr_resid) {
>
> There's still some more data in this extent? Set up the next bvec for
> the next receive:
>
>                          get_bvec_at(cursor, &bv);
>                          if (bv.bv_len > cursor->sr_resid)
>                                  bv.bv_len = cursor->sr_resid;
>                          if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
>                                  bv.bv_page = con->bounce_page;
>                                  bv.bv_offset = 0;
>                          }
>                          set_in_bvec(con, &bv);
>                          con->v2.data_len_remain -= bv.bv_len;
>
> ...and reduce the data_len_remain for the amount of that next bvec.
>
>                          return 0;
>                  }
>
> So yeah, I think this is not being decremented twice. The code is
> dealing with a different bvec at the point where data_len_remain is
> reduced above and it looks correct to me.

Okay, I think I misreading the sparse-read state machine.

> What problem are you trying to solve with this patch?

Currently no any issue from this. I just added many debug logs to 
reproduce and debug the issue https://tracker.ceph.com/issues/62081, and 
found odd logs. Such as the improvment for the other two patches:

  90279 <6>[ 5483.137183] libceph: osd_sparse_read:5923 ---> 
sr->sr_datalen: 251723776, sr->sr_index: 0, count: 0

The sr_datalen is not zero when the extents array is empty.

The following is a normal log, and the extent array size is 1.

  90275 <6>[ 5477.553113] libceph: osd_sparse_read:5919 ---> 
sr->sr_datalen: 16384, sr->sr_index: 0, count: 1

For this patch I just found it when going through the code. I will 
remove it for next version.

Thanks Jeff for your reviewing.

- Xiubo






