Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165BE4D919E
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Mar 2022 01:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344002AbiCOAcp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Mar 2022 20:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245732AbiCOAco (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Mar 2022 20:32:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 371BE5F8E
        for <ceph-devel@vger.kernel.org>; Mon, 14 Mar 2022 17:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647304292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7EBqnZ8mqaw+n24Sv6+8ZAJBh1i2JI4bSVlOC2YTgU=;
        b=IYEz+G7gTu+CIz/FTddFtaZqs8eDo3j8VdI2xRBqm+b85g3dNy2gDKOYRhBDhCQktq2yeZ
        6F/U9wsSP2GPR9TcwcRe1M25XDii7t0S1ujPJCXIGToA+tPCckW6aoHpMGVaE9RUySMPP1
        jX1R5dDRfOJj5wCCDtxaiAYeJSPHuB4=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-XRiyJ29jNsi82cV91VxhKA-1; Mon, 14 Mar 2022 20:31:30 -0400
X-MC-Unique: XRiyJ29jNsi82cV91VxhKA-1
Received: by mail-pj1-f71.google.com with SMTP id q21-20020a17090a2e1500b001c44f70fd38so6665210pjd.6
        for <ceph-devel@vger.kernel.org>; Mon, 14 Mar 2022 17:31:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=L7EBqnZ8mqaw+n24Sv6+8ZAJBh1i2JI4bSVlOC2YTgU=;
        b=hniieRzV4222pmxc1C7zWn7I5H7+fhcDvlmi5qNe0kaG+nbV6ArP0rOUD8Y2DthjKP
         mOxau8n5S95b9XE8ACtms7XC+ibCRsJe3oYzGigDTMSbq8pveAsz2st64zv1PolxaFm6
         wfQ/FESuZ3jVFpepdRWSPOmUdlW8wg/M9qK8ybzWeYPfrRAPMm9uo9fT4mvLpOGOVxv+
         41JYYISH83TGXvlhrmbqSQ0yTWA9JAL104eLTGlqXjIiJYZQE6S9hnkMlWxUN6PE1W2w
         AQLnS48t1dToiORz1sGdveqx8eJ5MhIqg4KBwIs9nc87e8z0SKVK4/1wKTR+h+ZHw/m+
         hGnQ==
X-Gm-Message-State: AOAM530bzPGLBCm2dp/OMdABiNbsEwj1WcZeBwegA0Ajf7GODYZHRxnh
        BCjFPkgPpqIJjPRSbfuBRrhcpM2fLCoJqoIzAFCGuLxQ3E2Rks6agN9P2JQqxYmaPc2pR8UP9WP
        Mv/DflzpcSKiL2LQmFe4NO/gOlHGHcn0CEhpP9Cf3uB7RB2r8PwGWL6xRpXp12FidFfhMqzQ=
X-Received: by 2002:aa7:85d8:0:b0:4f6:8ae9:16a8 with SMTP id z24-20020aa785d8000000b004f68ae916a8mr26389852pfn.15.1647304289039;
        Mon, 14 Mar 2022 17:31:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnxwvQbyA2xZBfgicVHI6ZU2eWsAIiUO2KLx64SBOKSppEifU6C7oT57Zvtnb0kWcJKeAWAA==
X-Received: by 2002:aa7:85d8:0:b0:4f6:8ae9:16a8 with SMTP id z24-20020aa785d8000000b004f68ae916a8mr26389830pfn.15.1647304288710;
        Mon, 14 Mar 2022 17:31:28 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x29-20020aa79a5d000000b004f0ef1822d3sm20586763pfj.128.2022.03.14.17.31.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 17:31:28 -0700 (PDT)
Subject: Re: [PATCH v2 0/4] ceph: dencrypt the dentry names early and once for
 readdir
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
References: <20220314022837.32303-1-xiubli@redhat.com>
 <6310d5de6cc441b07eb8144aab1c3c0fe3739e5a.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3d2dd743-4de9-9974-3d10-bd6bfe0445af@redhat.com>
Date:   Tue, 15 Mar 2022 08:31:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <6310d5de6cc441b07eb8144aab1c3c0fe3739e5a.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/15/22 2:38 AM, Jeff Layton wrote:
> On Mon, 2022-03-14 at 10:28 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This is a new approach to improve the readdir and based the previous
>> discussion in another thread:
>>
>> https://patchwork.kernel.org/project/ceph-devel/list/?series=621901
>>
>> Just start a new thread for this.
>>
>> As Jeff suggested, this patch series will dentrypt the dentry name
>> during parsing the readdir data in handle_reply(). And then in both
>> ceph_readdir_prepopulate() and ceph_readdir() we will use the
>> dencrypted name directly.
>>
>> NOTE: we will base64_dencode and dencrypt the names in-place instead
>> of allocating tmp buffers. For base64_dencode it's safe because the
>> dencoded string buffer will always be shorter.
>>
>>
>> V2:
>> - Fix the WARN issue reported by Luis, thanks.
>>
>>
>> Xiubo Li (4):
>>    ceph: pass the request to parse_reply_info_readdir()
>>    ceph: add ceph_encode_encrypted_dname() helper
>>    ceph: dencrypt the dentry names early and once for readdir
>>    ceph: clean up the ceph_readdir() code
>>
>>   fs/ceph/crypto.c     |  25 ++++++++---
>>   fs/ceph/crypto.h     |   2 +
>>   fs/ceph/dir.c        |  64 +++++++++------------------
>>   fs/ceph/inode.c      |  37 ++--------------
>>   fs/ceph/mds_client.c | 101 ++++++++++++++++++++++++++++++++++++-------
>>   fs/ceph/mds_client.h |   4 +-
>>   6 files changed, 133 insertions(+), 100 deletions(-)
>>
> This looks good, Xiubo. I did some testing with these earlier and they
> seemed to work great.
>
> I've gone ahead and merged these into the wip-fscrypt branch. It may be
> best to eventually squash these down, but it's probably fine to leave
> them on top as well.

Sure Jeff, thanks.

- Xiubo

> Thanks!

