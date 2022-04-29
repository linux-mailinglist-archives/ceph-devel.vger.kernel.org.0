Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230DB514251
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Apr 2022 08:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351287AbiD2Gb7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 Apr 2022 02:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiD2Gb5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 Apr 2022 02:31:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8EDA2B9F00
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 23:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651213719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YIzJ968dk8V0eV6yp1NEF8N1FiV7dvUeuvJplhnt9d0=;
        b=ix1ifX/QCHXP2TzilHa4bZRIZ98BmLDi1p3S8+KR5m8tasKAP7osjMxIQLJvIKTxapQaW6
        49mtieZJxIR+IqKvVcay5ayCm3on7cHWleByXzUTQT+ASZSwT8eGbyVz+9VJFcjOYR3E5P
        BUnFPg5+AoEyaZCB63+JkMYrc1HSvV0=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-R4kkt0NfMAS3CcuOqR0lxg-1; Fri, 29 Apr 2022 02:28:36 -0400
X-MC-Unique: R4kkt0NfMAS3CcuOqR0lxg-1
Received: by mail-pj1-f69.google.com with SMTP id w3-20020a17090ac98300b001b8b914e91aso3712042pjt.0
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 23:28:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YIzJ968dk8V0eV6yp1NEF8N1FiV7dvUeuvJplhnt9d0=;
        b=79+WvTr7nKjuek+GwL8ksPQVtLX5vJad3VAtj0knMOvU/5Tj2SzXv9b/am0V+0yu4L
         zXTzIng0LvOQ/VO4hVS9GEP/jfUbhXf8v53lrrKtv9S8awxm2mBD/M3pxvMNnPcOahBj
         TA4/q6LVbm/sL3tFwq7ov6WflNSUheQCNhL7rfKY8SAjahXEekj58xs0T5pqiUouAWYl
         FBxAFiWTOH0wtx0e42kZXef48CRYwT5cE8pNP8wLgJHU+vHoK0KlbyNc6CPTCmCDmIbC
         BKHRu12OiUGZqREtAbiTf6Kak5Bp0u3+AP5/OmAciNwV0/oWojug9R/ojEr3z/ahbvGP
         Xueg==
X-Gm-Message-State: AOAM53336cLN+POoGxejcNSPUdthtnt4tMO++qCUfUoIH2j2ILlh/I05
        mgAGpaTWug1uWuZbucNAk8AGFLXwoaqsPVHaf2okmlt02//6W7mSuEtThKI1CO7K66nxoOLYHbz
        t4vugiAclcnLfEM5kIWXovdPeIVCuag4+w251mJvupL3KozJyseeW9H+nVabc+PGsc2YgOMo=
X-Received: by 2002:a17:902:7009:b0:158:3bcf:b774 with SMTP id y9-20020a170902700900b001583bcfb774mr36667635plk.103.1651213714741;
        Thu, 28 Apr 2022 23:28:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8jTReLfS9WvxLg9jZU6lrg+yjgXJzWJRJXD0PHUWFVhexXG1jz/rb62RAibtpFrFhR4jQkg==
X-Received: by 2002:a17:902:7009:b0:158:3bcf:b774 with SMTP id y9-20020a170902700900b001583bcfb774mr36667612plk.103.1651213714266;
        Thu, 28 Apr 2022 23:28:34 -0700 (PDT)
Received: from [10.72.12.57] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c2-20020aa781c2000000b0050a7ff01d2bsm1802181pfn.30.2022.04.28.23.28.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 23:28:33 -0700 (PDT)
Subject: Re: [PATCH] ceph: don't retain the caps if they're being revoked and
 not used
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20220428121318.43125-1-xiubli@redhat.com>
 <CAAM7YAkVEEhhPtO7CJd6Cv6-2qc3EDHwAcU=zggxWSyKjm9aRA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8dff2592-03cb-0ef1-e538-ae4b0484c567@redhat.com>
Date:   Fri, 29 Apr 2022 14:28:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAM7YAkVEEhhPtO7CJd6Cv6-2qc3EDHwAcU=zggxWSyKjm9aRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/29/22 10:46 AM, Yan, Zheng wrote:
> On Thu, Apr 28, 2022 at 11:42 PM Xiubo Li <xiubli@redhat.com> wrote:
>> For example if the Frwcb caps are being revoked, but only the Fr
>> caps is still being used then the kclient will skip releasing them
>> all. But in next turn if the Fr caps is ready to be released the
>> Fw caps maybe just being used again. So in corner case, such as
>> heavy load IOs, the revocation maybe stuck for a long time.
>>
> This does not make sense. If Frwcb are being revoked, writer can't get
> Fw again. Second, Frwcb are managed by single lock at mds side.
> Partial releasing caps does make lock state transition possible.
>
Yeah, you are right. Checked the __ceph_caps_issued() it really has 
removed the caps being revoked already.

Thanks Zheng.


>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 0c0c8f5ae3b3..7eb5238941fc 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -1947,6 +1947,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>>
>>          /* The ones we currently want to retain (may be adjusted below) */
>>          retain = file_wanted | used | CEPH_CAP_PIN;
>> +
>> +       /*
>> +        * Do not retain the capabilities if they are under revoking
>> +        * but not used, this could help speed up the revoking.
>> +        */
>> +       retain &= ~((revoking & retain) & ~used);
>> +
>>          if (!mdsc->stopping && inode->i_nlink > 0) {
>>                  if (file_wanted) {
>>                          retain |= CEPH_CAP_ANY;       /* be greedy */
>> --
>> 2.36.0.rc1
>>

