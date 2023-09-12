Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A3779D162
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Sep 2023 14:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbjILMwo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 12 Sep 2023 08:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbjILMwn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 12 Sep 2023 08:52:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B5CBC4
        for <ceph-devel@vger.kernel.org>; Tue, 12 Sep 2023 05:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694523118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yUoLrF6mzUVTRLQoYu8HgLFz9cTWBrZK4rH+1ACpMnA=;
        b=YNIsehkGuJR4xMdaF+V/7bm88AA2heiQTEgpQQFfsi9VdDTlsPks+V9z2DcDjTi430Oor6
        fye1QPyGgqnoQkxD/PM5aBU/GcJRUw86pCp1ICH8XdqLVooCUPrLqhQmQEgdgepJIQ66ye
        uvyemRi9jwlOKUCZLQefl1gR126adio=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-r2ZZF82AMfiAd7IJuGRFBw-1; Tue, 12 Sep 2023 08:51:55 -0400
X-MC-Unique: r2ZZF82AMfiAd7IJuGRFBw-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-68fb5cea0a9so3647116b3a.1
        for <ceph-devel@vger.kernel.org>; Tue, 12 Sep 2023 05:51:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694523114; x=1695127914;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yUoLrF6mzUVTRLQoYu8HgLFz9cTWBrZK4rH+1ACpMnA=;
        b=w52hyUYjwkBFR4h/zaXyiMMnwP/eekCzfo5Y+MBKTrbu7HkR1YaxltslZmiUi2X5JU
         uW76eAEiyQXhmmWJaBT9ai5zdvE14PN7/xtil+0qKc72KwVEJ4Z9lHkuox+/trE9fVPP
         eewEodH1FXRiXy9TlRZEMGMUQ48pouIa3qRlY8SFIM1vxUggw34ktp5AFy4TIgtEYmr0
         WJADfx/wBEv1nwPjLoSvIZCSWlLgu+eFdX2Dy6sTgc7XbRDyoauRXwpVgBtnlE3kbjkj
         Y0kfh1glxcVgaVa/TF5WoYlUMnbNxQXxEXdMSjFSq8WUXLbe+YqXNyRR0ZwaO75RPeZg
         5vhg==
X-Gm-Message-State: AOJu0Yyz9QN9rJ/s/Tc8G2Rpd8cBT7FziUUQzK41VJLzd4mmuofHKmiO
        y0TzxZwIOfTGDjzGWkoHyQ0mdb+6c+rOsv2Olv5ViqAS/CM6TvarjlOsOQNBmF7DGRsVZLI6BPa
        rqHTUBotjVrbxL+XfEL+YSy0LRtIT7gKVKrU=
X-Received: by 2002:a05:6a20:1395:b0:14c:4e31:97f3 with SMTP id hn21-20020a056a20139500b0014c4e3197f3mr12000708pzc.59.1694523114326;
        Tue, 12 Sep 2023 05:51:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDyT3VYBF0HOW1WJ0U2ScPxB0ulJdM8Hpjd494vnvH1n1fPN2gIvhgwFb9MPbObVC6I77a/A==
X-Received: by 2002:a05:6a20:1395:b0:14c:4e31:97f3 with SMTP id hn21-20020a056a20139500b0014c4e3197f3mr12000698pzc.59.1694523113985;
        Tue, 12 Sep 2023 05:51:53 -0700 (PDT)
Received: from [10.72.113.154] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7858f000000b00682a27905b9sm7558802pfn.13.2023.09.12.05.51.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 05:51:53 -0700 (PDT)
Message-ID: <27e9617d-ef66-8110-f082-04ad29805a16@redhat.com>
Date:   Tue, 12 Sep 2023 20:51:50 +0800
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
 <53c5733b-8a94-66e3-4d05-97238d147d5b@redhat.com>
 <a9b51955-0f27-d802-4716-988af03a25e9@sec.uni-stuttgart.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <a9b51955-0f27-d802-4716-988af03a25e9@sec.uni-stuttgart.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/11/23 18:07, Sebastian Hasler wrote:
> On 11/09/2023 05:21, Xiubo Li wrote:
>
>> "This will generally not work if the file has  a  link  count of 
>> zero  (files  created  with  O_TMPFILE and without O_EXCL are an 
>> exception)."
> In this sentence, "generally" probably means "typically", so it 
> depends on the specific file system's behavior. I don't know the 
> CephFS behavior in this case. However, at least files created with 
> O_TMPFILE are an exception. Does CephFS support creating files with 
> O_TMPFILE? Such files can (and often will) go from the unlinked and 
> open state to the linked and closed state.
>
Hmm, yeah. I didn't see anywhere is disallowing to create with 
O_TMPFILE. Let me have a look at this case carefully later.

Thanks very much for your reporting Sebastian.

- Xiubo


