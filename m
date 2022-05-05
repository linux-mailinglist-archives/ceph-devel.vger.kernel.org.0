Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D366B51BEB3
	for <lists+ceph-devel@lfdr.de>; Thu,  5 May 2022 13:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236044AbiEEMB4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 May 2022 08:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbiEEMBz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 May 2022 08:01:55 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFA9E2C135
        for <ceph-devel@vger.kernel.org>; Thu,  5 May 2022 04:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651751894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K0jQylVFhXkqWH8WDyumvyecTvyszRnU+4smKs3ZXWw=;
        b=KC4FEKLlOj3fAsbGto11CfeJO5s9SJiBSTXKo4/ARp9abdxzshQP6exNsrPjQodZSwi7rT
        RqbKgvdX+98wkf6FJ2lb710zjnumi1HcAfj4A3n7M9/SWOVS6XyDVF62kS7njErcNCmP5u
        0RkS7gLUAKIBG4VBot7hiP/cBn4f5dM=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-R3YHOVDcOgKXH1tPXnY08g-1; Thu, 05 May 2022 07:58:14 -0400
X-MC-Unique: R3YHOVDcOgKXH1tPXnY08g-1
Received: by mail-pg1-f200.google.com with SMTP id l72-20020a63914b000000b003c1ac4355f5so2091606pge.4
        for <ceph-devel@vger.kernel.org>; Thu, 05 May 2022 04:58:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=K0jQylVFhXkqWH8WDyumvyecTvyszRnU+4smKs3ZXWw=;
        b=TCwKApkAjUi/KcztiDGCGFqsG8Rfr80GW1r36OGnICB4tOPMP3H3FKQBX6mUrVpfwi
         tSOiTXWUlfgOd25H95fvXlULukTyKWzoQMD32jS/QHqBMBpsyGEo/VJBpmtN4X+T/gCB
         zGWX52fiFOGCuvXwwlkNZOX0XkiMOJ0vQiYGBxkJ1rNvWJaLwYBpfO7TR1hpKs72+yh6
         j19DXYxOyEJIz7dmyM7wzFcy+nU/b4m6PTfesLf1foxBCmnYgA3Rk6YbXy+5cT1GUEQm
         +CgNA4TBTpCA67Lp9VKAx6+AuoV8aO6zHVjb1ux2Bho1YPAMYu7Y7ggGz6de7kO/ZiBb
         PS8A==
X-Gm-Message-State: AOAM532WPHAvKpUoemgaTpS3A8GWG3QxjRdlqhuysOCXU5SrbcXgyjrc
        lFwG0zyEhLxBHZZYOPTG8YmMnWfSq3OuBrRWGku7RBsNxlw/3XtBhhBHcmax+3C4KD9NUF10eKE
        Ardph7+nelyDjOP9fK8ne+su+6hVfycuCnL5o1S56Tz7O7vMJQZjIhLDvKhcI6BuWMh9P52s=
X-Received: by 2002:a17:902:9b94:b0:156:2c08:14a5 with SMTP id y20-20020a1709029b9400b001562c0814a5mr26806854plp.60.1651751892557;
        Thu, 05 May 2022 04:58:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJww2tFCcMytG+tJ9ItWcntJKLtlx4Xzrkdigci9xDC1mjur/PQX/YkLL9Omg/acJXFFZ+wH1w==
X-Received: by 2002:a17:902:9b94:b0:156:2c08:14a5 with SMTP id y20-20020a1709029b9400b001562c0814a5mr26806832plp.60.1651751892243;
        Thu, 05 May 2022 04:58:12 -0700 (PDT)
Received: from [10.72.12.122] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i15-20020a17090332cf00b0015e8d4eb20csm1377438plr.86.2022.05.05.04.58.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 04:58:11 -0700 (PDT)
Subject: Re: [PATCH] ceph: redirty the folio/page when offset and size are not
 aligned
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220505105808.35214-1-xiubli@redhat.com>
 <873fc305d96e023974cbc209c752a44de97eb88c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <196e050c-49e1-f812-1426-b47e5a1c4a55@redhat.com>
Date:   Thu, 5 May 2022 19:58:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <873fc305d96e023974cbc209c752a44de97eb88c.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/5/22 7:32 PM, Jeff Layton wrote:
> On Thu, 2022-05-05 at 18:58 +0800, Xiubo Li wrote:
>> At the same time fix another buggy code because in writepages_finish
>> if the opcode doesn't equal to CEPH_OSD_OP_WRITE the request memory
>> must have been corrupted.
>>
>> URL: https://tracker.ceph.com/issues/55421
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/addr.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index e52b62407b10..ae224135440b 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -146,6 +146,8 @@ static void ceph_invalidate_folio(struct folio *folio, size_t offset,
>>   	if (offset != 0 || length != folio_size(folio)) {
>>   		dout("%p invalidate_folio idx %lu partial dirty page %zu~%zu\n",
>>   		     inode, folio->index, offset, length);
>> +		filemap_dirty_folio(folio->mapping, folio);
>> +		folio_account_redirty(folio);
>>   		return;
>>   	}
>>   
> This looks wrong to me.
>
> How do you know the page was dirty in the first place? The caller should
> not have cleaned a dirty page without writing it back first so it should
> still be dirty if it hasn't. I don't see that we need to do anything
> like this.

Correct, check the history of the related commits and the vfs code, it's 
possible the page is none-dirty.

 From ceph_writepages_start() and writepage_nounlock() they will clear 
the dirty bit, and the same time the offset and size will be aligned 
too, so from ceph callers it should be okay.

The other case is from  mm/truncate.c, they don't care about the dirty bit.

>> @@ -733,8 +735,7 @@ static void writepages_finish(struct ceph_osd_request *req)
>>   
>>   	/* clean all pages */
>>   	for (i = 0; i < req->r_num_ops; i++) {
>> -		if (req->r_ops[i].op != CEPH_OSD_OP_WRITE)
>> -			break;
>> +		BUG_ON(req->r_ops[i].op != CEPH_OSD_OP_WRITE);
> I'd prefer we not BUG here. This does mean the data in the incoming
> frame was probably scrambled, but I don't see that as a good reason to
> crash the box.
>
> Throwing a warning message would be fine here, but a WARN_ON is probably
> not terribly helpful. Maybe add a pr_warn that dumps some info about the
> request in this situation (index, tid, flags, rval, etc...) ?
>
Looks good. Will fix it.

-- Xiubo

>>   
>>   		osd_data = osd_req_op_extent_osd_data(req, i);
>>   		BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);

