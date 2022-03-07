Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4444CEF07
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Mar 2022 01:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbiCGAu5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 6 Mar 2022 19:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiCGAu5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 6 Mar 2022 19:50:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F08603B3C6
        for <ceph-devel@vger.kernel.org>; Sun,  6 Mar 2022 16:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646614203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X0WG0rMGlmRyCSVW27fz8I+A01cj7PGLERfFubH34gE=;
        b=FfSH6FreMu+tWomu+esqGZR+vG5qo1eyq0rdeSceI1xgvqW1HvkszG9VWe7Ljel+Jte5O6
        cGW84g+8B2uj4k5R2NvGaII+oaAnvfteSRtoeJUeLTVWml6sGwEjK7thSokBovWfCVoK47
        dnCnaFl35MzyTcZTxZXYmq1c1pxHGx0=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-OvVYO8mSPX6TC5dBGxSzeA-1; Sun, 06 Mar 2022 19:50:01 -0500
X-MC-Unique: OvVYO8mSPX6TC5dBGxSzeA-1
Received: by mail-pg1-f198.google.com with SMTP id v8-20020a654608000000b0037d5ef9cfa0so3858038pgq.8
        for <ceph-devel@vger.kernel.org>; Sun, 06 Mar 2022 16:50:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=X0WG0rMGlmRyCSVW27fz8I+A01cj7PGLERfFubH34gE=;
        b=i53Pr91/CW6HYuUatP5ayF83J5X/UjAg0j6cJjnXa6Kizi8HgKSXJ3ycko+BSsLDRP
         fJr4GYIkl/PeWJPAJP0bRPlvcBSwT8h000TL0nNT102kQ8vTrCKKtUbr/pcZEdJ/WRcn
         2Nl8zbbxEv56J1DUmYqrfmP4cBXBz9HvZaaaWNIpptG95+d/kDPDoKgi4zy52j1FSa/B
         vD2JRDLcU9iIPk/l2Ppo7ToBkFO9xT7eHXbqEAO/vSWAoBY7x9XOop40fC6bkmz9aVmG
         fmCsz16ymrFybfJd4WayeF4K3EuGXTdI3AwLeiz7UXNXG5ypZU+3caxdVv+U3Ku/X9O2
         KtkQ==
X-Gm-Message-State: AOAM532FdYLfzuL3Dxx3mBO7lVZIrQ+bBSbMpjKNxBHcLgDsfCG6XPt5
        +OcK08JfQ64w+xsCaHGurNyNtAlUNchnBH0KmBo5ZPAPGoXbW4naWme7BJPZTpDR5SEiFjNJSDR
        Oy6uqHK9O2F1gb/rMm9CPjg==
X-Received: by 2002:a17:90b:33d2:b0:1bf:3b3f:cb60 with SMTP id lk18-20020a17090b33d200b001bf3b3fcb60mr10361462pjb.109.1646614200698;
        Sun, 06 Mar 2022 16:50:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxC9zybjienDQLfBb7NOhznbeTld6GwzNfEZil7xkCfHpWgcb+T0CDdcoM0zmVBwdrCx4gnzw==
X-Received: by 2002:a17:90b:33d2:b0:1bf:3b3f:cb60 with SMTP id lk18-20020a17090b33d200b001bf3b3fcb60mr10361444pjb.109.1646614200441;
        Sun, 06 Mar 2022 16:50:00 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s8-20020a056a0008c800b004f664655937sm14066594pfu.157.2022.03.06.16.49.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 16:49:59 -0800 (PST)
Subject: Re: [PATCH 0/3] ceph: minor fixes and encrypted snapshot names
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220304161403.19295-1-lhenriques@suse.de>
 <87fsnx4rb3.fsf@brahms.olymp>
 <e7f91d0be0f41320e5a4f38ded1bde166626a17f.camel@kernel.org>
 <878rtoo3bi.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <66d31a84-2774-3fa1-2a0e-e9125c484755@redhat.com>
Date:   Mon, 7 Mar 2022 08:49:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <878rtoo3bi.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
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


On 3/5/22 10:56 PM, Luís Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
>
>> On Fri, 2022-03-04 at 16:26 +0000, Luís Henriques wrote:
>>> Luís Henriques <lhenriques@suse.de> writes:
>>>
>>>> Hi!
>>>>
>>>> I'm sending another iteration of the encrypted snapshot names patch.  This
>>>> patch assumes PR#45224 [1] to be merged as it adds support for the
>>>> alternate names.
>>>>
>>>> Two notes:
>>>>
>>>> 1. Patch 0001 is just a small fix from another fscrypt patch.  It's
>>>>     probably better to simply squash it.
>>>>
>>>> 2. I'm not sure how easy it is to hit the UAF fixed by patch 0002.  I can
>>>>     reproduce it easily by commenting the code that adds the
>>>>     DCACHE_NOKEY_NAME flag in patch 0003.
>>> Obviously, immediately after sending this patchset I realized I failed to
>>> mention a very (*VERY*) important note:
>>>
>>> Snapshot names can not start with a '_'.  I think the reason is related
>>> with the 'long snapshot names', but I can't really remember the details
>>> anymore.  The point is that an encrypted snapshot name base64-encoded
>>> *may* end-up starting with an '_' as we're using the base64-url variant.
>>>
>>> I really don't know if it's possible to fix that.  I guess that in that
>>> case the user will get an error and fail to create the snapshot but he'll
>>> be clueless because the reason.  Probably a warning can be added to the
>>> kernel logs, but maybe there are other ideas.
>>>
>>
>> Ouch. Is that imposed by the MDS? It'd be best if we could remove that
>> limitation from it altogether if we can.
> I do remember hitting this limitation in the past, but a quick grep didn't
> show anything in the documentation about it.  This seems to have been
> added to the MDS a *long* time ago, with commit 068553473c82 ("mds: adjust
> trace encoding, clean up snap naming") but (as usual) there aren't a lot
> of details.

When making a snapshot and in MDS code:

10458   if (snapname.length() == 0 ||
10459       snapname[0] == '_') {
10460     respond_to_request(mdr, -CEPHFS_EINVAL);
10461     return;
10462   }


>> If we can't, then we might be able to get away with prepending all the
>> encrypted names with some legal characte. Then when we go to decrypt it
>> we just strip that off.
> This is probably the best way to fix it, but it's worth trying to find
> out the origins of this limitation.  I do seem to remember some obscure
> reasons, related with the long snap names (for which Xiubo has a patch),
> which will start with '_'.  But yeah I'll have to go dig deeper.

It will recognize the encrypted "_XYZ_${DIGIT}" snapshot name as the 
long snapshot name inherited from its parent snap realm, and will parse 
the "${DIGIT}" as an ino in other places.

Maybe in MDS we should fail the request only when snapshot name is in 
type of "_XYZ_${DIGIT}" instead of only "_XYZ", and in client side 
should also print one error or warn log about this ?

This why added the ceph PR[1] to tell the kclient current snapshot name 
is a long snap name in lssnap. So if we can forbid the snap shot name 
begin with '_' it will simple in kclient code to handle the long snap 
name, or it will be complex in both MDS and kclient.

[1] https://github.com/ceph/ceph/pull/45208

-- Xiubo


>> We could also consider changing the base64 routine to use something else
>> in lieu of '_' but that's more of a hassle.
> Cheers,

