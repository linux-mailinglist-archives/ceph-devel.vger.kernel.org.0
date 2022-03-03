Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F374A4CB520
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Mar 2022 03:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbiCCCuY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 21:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbiCCCuX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 21:50:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98FAD15D38C
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 18:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646275777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KqxkB+NW0awtsur8RGA1AGp9E9G6B6AEPQP/Txhu/XA=;
        b=MiqN9Y0l5JvbGUsj3HYZNaghgkWJOOi8OdWNOaTKvI6gxGhR378CYKw3mc5jikaoLixDaj
        izhhj0ugqWjs6ULBFXRZxeSt68lkLy9KfS/AIisUkqb5EK+v1SERSC+DgcMCYo5bz+lIHK
        GnxgnYSZ7sEArCTyYrMgCzsIyJmroa4=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-cIKxLsOLPW2JUH6t2HL-Tg-1; Wed, 02 Mar 2022 21:49:36 -0500
X-MC-Unique: cIKxLsOLPW2JUH6t2HL-Tg-1
Received: by mail-pf1-f198.google.com with SMTP id i72-20020a62874b000000b004f66c5b963cso592735pfe.6
        for <ceph-devel@vger.kernel.org>; Wed, 02 Mar 2022 18:49:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KqxkB+NW0awtsur8RGA1AGp9E9G6B6AEPQP/Txhu/XA=;
        b=6IDoIkaKJvRQcA/csco1Mo54bLS4XDKEADu/s2h7mqu69ODCMK5yAUwcqPlJwh8AY8
         2fvL+ys88xJummRSjfbn3JtoFxjoy2S7D2UkJUi4JjgRrEnqLKKOwYowLoKr81A5fE2v
         rWTV0gC6dB++IVM/lD9nVCXCCLN02UFxz9kKoIvs/6uoPIaij9SFCOfEsSTmfiKJzj+d
         sOsV6XwSY7zm0JHrei6LJY8eu8ypLuNVYhNrDaLOrGgNwnxHchmoJfs/HYAG4gJupWfC
         MUoFxobNs7Bz2JM+Y7FhnwutU+efKUodsz/palH602gQEWkEGew4mNHbb73BxxwFz1oE
         sdlQ==
X-Gm-Message-State: AOAM5316d78b3aArBv78xQksbzdlbEfKI7WWnvExx6CIeh7NlvvCpUE+
        8PEA92KxSRRKaVN5QhaSgAKIiEMPCznzUavYsXo7XsDr6fpxCNAWf0XGfQKu9BtRt6Cov2VDdhy
        rTPbQwX+r54SfRIXYQmk1FhRLRF/k1J8nzUorapM5Z12+MqyxL4KpZSsYGFVEHfiiH0dVe4M=
X-Received: by 2002:a17:902:8698:b0:151:488f:3dee with SMTP id g24-20020a170902869800b00151488f3deemr25169553plo.9.1646275774591;
        Wed, 02 Mar 2022 18:49:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyy/0jjrLJ+A0pHJfUYi/Q0FZd3DYgXnITLAtGqMg3+Vlnpvi4gK33DtQHcApTObnWl1ZrFMA==
X-Received: by 2002:a17:902:8698:b0:151:488f:3dee with SMTP id g24-20020a170902869800b00151488f3deemr25169523plo.9.1646275774047;
        Wed, 02 Mar 2022 18:49:34 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm475057pgs.10.2022.03.02.18.49.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 18:49:33 -0800 (PST)
Subject: Re: [PATCH v3 0/6] ceph: encrypt the snapshot directories
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220302121323.240432-1-xiubli@redhat.com>
 <87mti88isf.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4a879416-86dc-fdca-7cb3-36aff28f5ce8@redhat.com>
Date:   Thu, 3 Mar 2022 10:49:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87mti88isf.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/2/22 11:40 PM, Luís Henriques wrote:
> Hi Xiubo,
>
> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This patch series is base on the 'wip-fscrypt' branch in ceph-client.
> I gave this patchset a try but it looks broken.  For example, if 'mydir'
> is an encrypted *and* locked directory doing:
>
> # ls -l mydir/.snap
>
> will result in:
>
> fscrypt (ceph, inode 1099511627782): Error -105 getting encryption context

Sorry, I forgot to mention you need the following ceph PRs:

https://github.com/ceph/ceph/pull/45208

https://github.com/ceph/ceph/pull/45192


> My RFC patch had an issue that I haven't fully analyzed (and that I
> "fixed" using the d_drop()).  But why is the much simpler approach I used
> not acceptable? (I.e simply use fscryt_auth from parent in
> ceph_get_snapdir()).

Sorry, I missed reading your patch. I will check more carefully about that.

This patch series is mainly supporting other features, that is the long 
snap names inheirt from parent snaprealms.

I will drop the related patch here and cherry-pick to use yours then and 
do the test.

- Xiubo

>
>> V3:
>> - Add more detail comments in the commit comments and code comments.
>> - Fix some bugs.
>> - Improved the patches.
>> - Remove the already merged patch.
>>
>> V2:
>> - Fix several bugs, such as for the long snap name encrypt/dencrypt
>> - Skip double dencypting dentry names for readdir
>>
>> ======
>>
>> NOTE: This patch series won't fix the long snap shot issue as Luis
>> is working on that.
> Yeah, I'm getting back to it right now.  Let's see if I can untangle this
> soon ;-)
>
> Cheers,

