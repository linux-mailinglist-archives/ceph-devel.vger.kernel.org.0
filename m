Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B6579A1CE
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Sep 2023 05:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjIKDWl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 10 Sep 2023 23:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbjIKDWj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 10 Sep 2023 23:22:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED35CE3
        for <ceph-devel@vger.kernel.org>; Sun, 10 Sep 2023 20:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694402493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qdjcZP16VHvfCJE3leLALtyR4nzIGf8kbEK1WA7tRJE=;
        b=C2xPThau1vT8sk5r3ylPwQYO9o+UXsPgMRLbiT2Jl/phIV3B+ekd+He5EDS9spSNbbe20c
        CHnP3J82913pQISzyhpkX75UgduBkFC5QmH3DrVRsPZNn2Mq1WGcTjFTcku5VS3Yq6rUMb
        nL1F4XM8vUJb4UupZ7IspV05ll0UgTQ=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-ihQ9hPL4OqSfO7XSyIsRXA-1; Sun, 10 Sep 2023 23:21:32 -0400
X-MC-Unique: ihQ9hPL4OqSfO7XSyIsRXA-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6bb31a92b44so4540535a34.0
        for <ceph-devel@vger.kernel.org>; Sun, 10 Sep 2023 20:21:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694402491; x=1695007291;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qdjcZP16VHvfCJE3leLALtyR4nzIGf8kbEK1WA7tRJE=;
        b=ObGdpwyfFRTOoemDzmakJ2ZujtTIeLk5tNMZt+JOsfOSI0x+05HAfK4mKgXHx4lalB
         04BXRjc6LwbP13Ro/86KmBz9JfoOu6ErRuB1QzRuuq14ZN3FlNQCiRyoipqSit5Xqb2H
         xWYe4EPUGFT9NzW4LkmHjl2VI8xuRoSYPx5EHKPzd4+XSb0HiDKBYewOVKPpIGHqDbHt
         n/U1S19SYk14LbWhaJHjtZ8IESSWBhTt3ygqXI9QHsTNWPkI+zM/jVTk1oyCa2fB2FEO
         4/3pPOFTpU/5bzvDsMv4NpvDPaEX3VRvgO7yCvwSbd1dgFuV9h5k06fzbtdOGvaTMgSc
         gXcg==
X-Gm-Message-State: AOJu0YwqHSwSpvygEucSEdXbRr88+qDg3gkK9M8vEPU2Z3ksyDiim6Ch
        agF+ox+hfPWxCuUrlhybwbcRYRtbbzif8sSAW1fxxz7bw/qAsvBvIGOq3Abney5wGYHy41RLE1J
        qr3LIPufMQWZbCWHGLgZPLMYUfy64kDpR
X-Received: by 2002:a05:6830:468f:b0:6bf:2d48:f064 with SMTP id ay15-20020a056830468f00b006bf2d48f064mr8370377otb.13.1694402491258;
        Sun, 10 Sep 2023 20:21:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGi2rkUdCsgTpqbnLvx/KSX0EIveRF6a+pSgOH99NDBR7RbzuXNXQLEKxbvkFgY3/cUc3f+EQ==
X-Received: by 2002:a05:6830:468f:b0:6bf:2d48:f064 with SMTP id ay15-20020a056830468f00b006bf2d48f064mr8370371otb.13.1694402491037;
        Sun, 10 Sep 2023 20:21:31 -0700 (PDT)
Received: from [10.72.112.122] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a23-20020a056a001d1700b006889664aa6csm1354396pfx.5.2023.09.10.20.21.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Sep 2023 20:21:30 -0700 (PDT)
Message-ID: <53c5733b-8a94-66e3-4d05-97238d147d5b@redhat.com>
Date:   Mon, 11 Sep 2023 11:21:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: fail the open_by_handle_at() if the dentry is being
 unlinked
Content-Language: en-US
To:     Sebastian Hasler <sebastian.hasler@sec.uni-stuttgart.de>
Cc:     ceph-devel@vger.kernel.org
References: <20220804080624.14768-1-xiubli@redhat.com>
 <e60ea973-d323-1d4d-c03b-0ee4779735c4@sec.uni-stuttgart.de>
 <3f6b622d-8513-f289-5146-546c1f747e10@redhat.com>
 <6dc123eb-7251-03a6-87ce-abe11925e2e3@sec.uni-stuttgart.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <6dc123eb-7251-03a6-87ce-abe11925e2e3@sec.uni-stuttgart.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/7/23 19:57, Sebastian Hasler wrote:
> On 07/09/2023 04:05, Xiubo Li wrote:
>>
>> int linkat(int olddirfd, const char *oldpath, int newdirfd, const 
>> char *newpath, int flags);
>>
>> BTW, for "an open file descripter", do you mean "olddirfd" ? Because 
>> "olddirfd" is a dir's open file descripter, how is that possible it 
>> can become linked again ?
>
> Yes, I mean olddirfd, and the manual says: "If oldpath is an empty 
> string, create a link to the file referenced by olddirfd".
>
Yeah, in this case will it allow to be a regular file's file descriptor. 
And in the mannual page:

"This will generally not work if the file  has  a  link  count of  zero  
(files  created  with  O_TMPFILE  and without O_EXCL are an exception)."

I haven't gone through the code yet. Is that means we won't allow the 
linkat() if the inode->i_count is zero ?

Thanks

