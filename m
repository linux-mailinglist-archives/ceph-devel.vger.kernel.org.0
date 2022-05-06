Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E83751CD5D
	for <lists+ceph-devel@lfdr.de>; Fri,  6 May 2022 02:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387218AbiEFAH2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 May 2022 20:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbiEFAH1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 May 2022 20:07:27 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC023F07
        for <ceph-devel@vger.kernel.org>; Thu,  5 May 2022 17:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651795420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AbvRPWlOwqDR3QQQ42VD3G8+Hpm79Ge9smqVBNzO7Iw=;
        b=YNBb083/3xBXFw9Q2+eiAZzi5bW364amHgnXL20P8z407NumGPgm0cWGTy1D8hpLhTUQdN
        rs5QXYuDV80l9LpDvTuEW1vSwZe12OTy6yqTVSo62FxchcALu0h2Ejgr/8b8q2qv+uW7AM
        OtML1mslgRBwwt3AUQd79J8u52ZxJdM=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-wkV6CcU-Mw-jRRq6t8WyPw-1; Thu, 05 May 2022 20:03:40 -0400
X-MC-Unique: wkV6CcU-Mw-jRRq6t8WyPw-1
Received: by mail-pf1-f199.google.com with SMTP id x16-20020aa793b0000000b0050d3d5c4f4eso1752839pff.6
        for <ceph-devel@vger.kernel.org>; Thu, 05 May 2022 17:03:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AbvRPWlOwqDR3QQQ42VD3G8+Hpm79Ge9smqVBNzO7Iw=;
        b=Vjr5G6K/+LtZA7/ZrgMKl2Bpi5eKHzCZYC5+RIf4UPL880hKsI11dmnW+yNPUcl9FJ
         KvKpb4fMMrqFlsWzQbNj6G5P0upn4sdfXT3wArtD4toml7xWkP7+veE5pxtoXgU53Xwj
         SBmvLvPzTDYVtm1ruIcCew5Lfhxo87Ul41srb7MBOrnWSF2B2NeAdfTLAHYbJSx4E/pB
         YTa6veem/I2ymVk/qrq9qy0f7DqDIPmICD0Bj8rGf6ItqReHDGuj/8Pi1RLYhqaFpc8l
         xCC817GMS4RWDCIYFeFn4U4S4uePORazWUOBaYPZCv1vmvGLVSm/SS4Dy6SNHBOtbLcC
         VlnQ==
X-Gm-Message-State: AOAM533QyFMEyFqzwYHPLoVLo81MwI+bV6h81G0HbZfagI0c4n+8UFzo
        NA6g66gCur6hKfz80Z6JtXjAWsPs1mQXyDUZKjfu/Dk0GAglUodPoT2BwT0IMBZn7i6/AI8wxZJ
        1+J3C4HQRmC9r8VR6tTa+chHlYDmAEqMM0pevbeYPjiTEGfpahVXVWEWmNW3CDMfQ1+O4cfQ=
X-Received: by 2002:a17:903:2d0:b0:14d:8a8d:cb1 with SMTP id s16-20020a17090302d000b0014d8a8d0cb1mr799861plk.50.1651795418388;
        Thu, 05 May 2022 17:03:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPLGPzjdhJRciLBPkrOHh8DqwcmqTGdXo2VshHmz4LohDYsZCSQJUkfzS9GhfP6q9lRNvIyQ==
X-Received: by 2002:a17:903:2d0:b0:14d:8a8d:cb1 with SMTP id s16-20020a17090302d000b0014d8a8d0cb1mr799821plk.50.1651795417933;
        Thu, 05 May 2022 17:03:37 -0700 (PDT)
Received: from [10.72.12.122] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s16-20020a62e710000000b0050dc76281d8sm2010696pfh.178.2022.05.05.17.03.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 17:03:37 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: switch to VM_BUG_ON_FOLIO and continue the loop
 for none write op
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220505124718.50261-1-xiubli@redhat.com>
 <f7f4a70b0916ec077c2a72c52002630f9e898fd9.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8c86c449-467f-b8c9-e68c-1fc9b659e74c@redhat.com>
Date:   Fri, 6 May 2022 08:03:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <f7f4a70b0916ec077c2a72c52002630f9e898fd9.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
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


On 5/5/22 9:25 PM, Jeff Layton wrote:
> On Thu, 2022-05-05 at 20:47 +0800, Xiubo Li wrote:
>> Use the VM_BUG_ON_FOLIO macro to get more infomation when we hit
>> the BUG_ON, and continue the loop when seeing the incorrect none
>> write opcode in writepages_finish().
>>
>> URL: https://tracker.ceph.com/issues/55421
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/addr.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index e52b62407b10..d4bcef1d9549 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -122,7 +122,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
>>   	 * Reference snap context in folio->private.  Also set
>>   	 * PagePrivate so that we get invalidate_folio callback.
>>   	 */
>> -	BUG_ON(folio_get_private(folio));
>> +	VM_BUG_ON_FOLIO(folio_get_private(folio), folio);
>>   	folio_attach_private(folio, snapc);
>>   
>>   	return ceph_fscache_dirty_folio(mapping, folio);
>> @@ -733,8 +733,11 @@ static void writepages_finish(struct ceph_osd_request *req)
>>   
>>   	/* clean all pages */
>>   	for (i = 0; i < req->r_num_ops; i++) {
>> -		if (req->r_ops[i].op != CEPH_OSD_OP_WRITE)
>> -			break;
>> +		if (req->r_ops[i].op != CEPH_OSD_OP_WRITE) {
>> +			pr_warn("%s incorrect op %d req %p index %d tid %llu\n",
>> +				__func__, req->r_ops[i].op, req, i, req->r_tid);
>> +			continue;
> A break here is probably fine. We don't expect to see any non OP_WRITE
> ops in here, so if we do I don't see the point in continuing.
>
I am afraid if the non OP_WRITE op is in middle of the r_ops[], for the 
following OP_WRITE ops we may miss some pages with the dirty bit cleared 
but with the private data kept ?

For this check I didn't in which case will the non OP_WRITE ops will 
happen unless the request is corrupted.

-- Xiubo

>> +		}
>>   
>>   		osd_data = osd_req_op_extent_osd_data(req, i);
>>   		BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);
> Otherwise looks fine.

