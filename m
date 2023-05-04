Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4A66F6407
	for <lists+ceph-devel@lfdr.de>; Thu,  4 May 2023 06:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjEDE1s (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 May 2023 00:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjEDE1q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 May 2023 00:27:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E0CE7
        for <ceph-devel@vger.kernel.org>; Wed,  3 May 2023 21:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683174420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OMMeDMsMLT9JMX//LoTOT7bWchyk6wUNMG2heNoyp6w=;
        b=QfOqLqUFewT817dPWwfiTlmIyMrH31OtoWYvH6uiq9PFZyppPc/kOC00uo5TolaDvFLJZk
        PB/w57zP85VCUnFS6rjTgPgEd7yKNuQLb7CSTckCK/pRtKbaKRpLR6xpW+d1pCokUNRXzK
        pYg3b2bxHXo8IaQ06yHRGSLPCOCWylc=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-TItrOL_8P_qi_Qa-QWhDUg-1; Thu, 04 May 2023 00:26:59 -0400
X-MC-Unique: TItrOL_8P_qi_Qa-QWhDUg-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-51b49840df8so3036684a12.2
        for <ceph-devel@vger.kernel.org>; Wed, 03 May 2023 21:26:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683174418; x=1685766418;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OMMeDMsMLT9JMX//LoTOT7bWchyk6wUNMG2heNoyp6w=;
        b=atDCr1chyOwtN54HkYSmKCdaXxuV360zRwYxEb/X6QLvGjECi4KKnRzIt5ldrwXGwu
         zRb8Hx7MdSEifHrLyFxYhA8rcqoPQshmRw++i/WahxHHK70u8PFmCoXG9cbP4NgXWF/K
         ckQ/Ou3uvsY8L2x2hRBsneLsjXAilFHJVdHai9Ie5zrhgQTh3LOfyPIeGzLWb7d/xgRu
         fzM6s0KkLlYMNFEkiUYbmxZ7otuq2G8fEC22f0P4JyP0QJxBOHutJniLPUsrnj3Y4pqV
         UfrXA3q5rE0LOVzUGsvjdJEy5HteRMEWuS+qQorUgzqVFzpKJwII34gQnSHexQduDl2H
         RvvA==
X-Gm-Message-State: AC+VfDwzuoEODlqR0rR8I5eOZjsmPjXRAbZ0CGOMIWepnlwdcgSd4DZo
        J4HS12VGPqSLnUKExnEX6kNEKA7SQh0jWrxFbQkXVUiutGZeM8I/czmmbwI6Zk8eTxjxRPlJgCt
        NKlto6+qkm6zrcJy4E3nCYkeBcI+T1Cuc
X-Received: by 2002:a05:6a20:a585:b0:e7:4f8a:d04d with SMTP id bc5-20020a056a20a58500b000e74f8ad04dmr867311pzb.57.1683174418073;
        Wed, 03 May 2023 21:26:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6MqLo4/dN7c7LrKdut8GFrLxLM/Tbf9HTb+87opQzgu5KPUVAXyz9kAdcE6p+pG0eIoXOlVg==
X-Received: by 2002:a05:6a20:a585:b0:e7:4f8a:d04d with SMTP id bc5-20020a056a20a58500b000e74f8ad04dmr867296pzb.57.1683174417771;
        Wed, 03 May 2023 21:26:57 -0700 (PDT)
Received: from [10.72.12.151] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q14-20020aa7842e000000b00640dbbd7830sm18703812pfn.18.2023.05.03.21.26.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 21:26:57 -0700 (PDT)
Message-ID: <16ef3f79-2c91-31f7-bf82-2db40c7550d4@redhat.com>
Date:   Thu, 4 May 2023 12:26:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] ceph: fix blindly expanding the readahead windows
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, lhenriques@suse.de
References: <20230323070105.201578-1-xiubli@redhat.com>
 <CAOi1vP_cX3U-Xs72-fXDrxT+e_hEkUi6xtZc_3Cm7ko1ZT_BLQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_cX3U-Xs72-fXDrxT+e_hEkUi6xtZc_3Cm7ko1ZT_BLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/30/23 19:00, Ilya Dryomov wrote:
> On Thu, Mar 23, 2023 at 8:01 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Blindly expanding the readahead windows will cause unneccessary
>> pagecache thrashing and also will introdue the network workload.
>> We should disable expanding the windows if the readahead is disabled
>> and also shouldn't expand the windows too much.
>>
>> Expanding forward firstly instead of expanding backward for possible
>> sequential reads.
>>
>> URL: https://www.spinics.net/lists/ceph-users/msg76183.html
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/addr.c | 23 +++++++++++++++++------
>>   1 file changed, 17 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index ca4dc6450887..01d997f6c66c 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -188,16 +188,27 @@ static void ceph_netfs_expand_readahead(struct netfs_io_request *rreq)
>>          struct inode *inode = rreq->inode;
>>          struct ceph_inode_info *ci = ceph_inode(inode);
>>          struct ceph_file_layout *lo = &ci->i_layout;
>> +       unsigned long max_pages = inode->i_sb->s_bdi->ra_pages;
>> +       unsigned long max_len = max_pages << PAGE_SHIFT;
>> +       unsigned long len;
>>          u32 blockoff;
>>          u64 blockno;
>>
>> -       /* Expand the start downward */
>> -       blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
>> -       rreq->start = blockno * lo->stripe_unit;
>> -       rreq->len += blockoff;
>> +       /* Readahead is disabled */
>> +       if (!max_pages)
>> +               return;
>> +
>> +       /* Expand the length forward by rounding up it to the next block */
>> +       len = roundup(rreq->len, lo->stripe_unit);
>> +       if (len <= max_len)
>> +               rreq->len = len;
> Hi Xiubo,
>
> This change makes it possible for the request to be expanded into the
> next block (i.e. it's not rounded _up_ to the next block as the comment
> says) because rreq->len is no longer guaranteed to be based off of the
> start of the block here.  Previously that was ensured by the preceding
> downward expansion.

Correct. I will fix it.

Thanks Ilya.

- Xiubo


> Thanks,
>
>                  Ilya
>

