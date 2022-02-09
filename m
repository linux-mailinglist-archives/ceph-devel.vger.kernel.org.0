Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C420B4AEA00
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Feb 2022 07:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiBIGF2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Feb 2022 01:05:28 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbiBIGAq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Feb 2022 01:00:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30D67E01090F
        for <ceph-devel@vger.kernel.org>; Tue,  8 Feb 2022 22:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644386429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C+LEMdJDd9hwAEdIQGiPzM4vUvNX6MavtkmQaBsLfWY=;
        b=iLPBVHGw4RZQ9Jcawiq/dORIvFHYxnPqTkNJ0fRifIureIfcISByws5I1q73mv1+z/OZpH
        JoF26XLldqrpFS81qMaWB1sx/zpohcKOPPqdV0p4PnzI9l+5D4UsVec1verKno0unBbEdy
        pwz10cIRmK8/ccN9pWcba9DRSN4y1Ss=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-qZig7NttOn-RwsOr2F3UsA-1; Wed, 09 Feb 2022 01:00:28 -0500
X-MC-Unique: qZig7NttOn-RwsOr2F3UsA-1
Received: by mail-pj1-f71.google.com with SMTP id 18-20020a17090a1a1200b001b9117f2f76so1077531pjk.1
        for <ceph-devel@vger.kernel.org>; Tue, 08 Feb 2022 22:00:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=C+LEMdJDd9hwAEdIQGiPzM4vUvNX6MavtkmQaBsLfWY=;
        b=1PEZ+FzyNzH2Ob31WvIAgQY1srlHTFAjY6lGPVZ3LQEYpr6QvRo4i9iTqqXd6P6Fvy
         5iamrs9FOZTGNbT/J9ohZNv4Nz7igFGOCsIYnIJJAip6NUK5VZzwrmK9rGWn4GCZmptP
         3ZeTwcjcgSAQDVyVUVQdGeAMyc4MflgE0L4RA73qMoM8p9g+PA9e14aH7sYv05YwOcwc
         ZbH6hP7ULP4HvGshg4cDFa+mSJhckDlPDy4cP3fQDvPwvfU/gpy7wxPWvtZqeBN9AIoq
         EghdwVfX/jFTc3uPPHyCDXUsgfwkTcjVWKIWTjo7SvgALlHpCusX4mZezJGG5XLp31xC
         J9hw==
X-Gm-Message-State: AOAM530939KdGkZEeoISIyK2i875OsLTHjzp+wM7whSOmAnm5R+irZ9F
        W3zcR2xZcIcKQyrPgXVBKz9LNPutJKEQS3AvY70UjMivdRrcvKIknoPbHG0SZFd2yyTTngg4xyX
        TTtZSrXrkbxF4mtn3J6Q+Gw==
X-Received: by 2002:a17:90a:9e5:: with SMTP id 92mr840415pjo.128.1644386426996;
        Tue, 08 Feb 2022 22:00:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwsS4hFM3Nvxf35TgqoU/Y5SIyKAqI9OiLcj4BJFQRRaNleu92bQ+RsyIL8c8AD8kjy/Td1fw==
X-Received: by 2002:a17:90a:9e5:: with SMTP id 92mr840387pjo.128.1644386426646;
        Tue, 08 Feb 2022 22:00:26 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f22sm18155007pfj.206.2022.02.08.22.00.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 22:00:26 -0800 (PST)
Subject: Re: [PATCH] ceph: fail the request directly if handle_reply gets an
 ESTALE
To:     Jeff Layton <jlayton@kernel.org>,
        Gregory Farnum <gfarnum@redhat.com>
Cc:     Dan van der Ster <dan@vanderster.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@newdream.net>, ukernel <ukernel@gmail.com>
References: <20220207050340.872893-1-xiubli@redhat.com>
 <77bd8ec8fb97107deb57c641b5e471b8eeb828c8.camel@kernel.org>
 <CAJ4mKGbHyn-oQwL8D3Ove0d2tD++VEXOTMSj5EDbcBk3SFX=2w@mail.gmail.com>
 <d6f16704da303eca4d62aee58eecacb45f76f45a.camel@kernel.org>
 <CAJ4mKGb3j_QNMuKmccoj43jswoReb_iP8wnJi3f-mpaN++PC7w@mail.gmail.com>
 <9ee4afece5bc3445ed19a3344a11eeab697ff37e.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3e2d66b0-a0e9-be31-a803-f7a4ff687c78@redhat.com>
Date:   Wed, 9 Feb 2022 14:00:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <9ee4afece5bc3445ed19a3344a11eeab697ff37e.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/8/22 1:11 AM, Jeff Layton wrote:
> On Mon, 2022-02-07 at 08:28 -0800, Gregory Farnum wrote:
>> On Mon, Feb 7, 2022 at 8:13 AM Jeff Layton <jlayton@kernel.org> wrote:
>>> The tracker bug mentions that this occurs after an MDS is restarted.
>>> Could this be the result of clients relying on delete-on-last-close
>>> behavior?
>> Oooh, I didn't actually look at the tracker.
>>
>>> IOW, we have a situation where a file is opened and then unlinked, and
>>> userland is actively doing I/O to it. The thing gets moved into the
>>> strays dir, but isn't unlinked yet because we have open files against
>>> it. Everything works fine at this point...
>>>
>>> Then, the MDS restarts and the inode gets purged altogether. Client
>>> reconnects and tries to reclaim his open, and gets ESTALE.
>> Uh, okay. So I didn't do a proper audit before I sent my previous
>> reply, but one of the cases I did see was that the MDS returns ESTALE
>> if you try to do a name lookup on an inode in the stray directory. I
>> don't know if that's what is happening here or not? But perhaps that's
>> the root of the problem in this case.
>>
>> Oh, nope, I see it's issuing getattr requests. That doesn't do ESTALE
>> directly so it must indeed be coming out of MDCache::path_traverse.
>>
>> The MDS shouldn't move an inode into the purge queue on restart unless
>> there were no clients with caps on it (that state is persisted to disk
>> so it knows). Maybe if the clients don't make the reconnect window
>> it's dropping them all and *then* moves it into purge queue? I think
>> we need to identify what's happening there before we issue kernel
>> client changes, Xiubo?
>
> Agreed. I think we need to understand why he's seeing ESTALE errors in
> the first place, but it sounds like retrying on an ESTALE error isn't
> likely to be helpful.

There has one case that could cause the inode to be put into the purge 
queue:

1, When unlinking a file and just after the unlink journal log is 
flushed and the MDS is restart or replaced by a standby MDS. The unlink 
journal log will contain the a straydn and the straydn will link to the 
related CInode.

2, The new starting MDS will replay this unlink journal log in 
up:standby_replay state.

3, The MDCache::upkeep_main() thread will try to trim MDCache, and it 
will possibly trim the straydn. Since the clients haven't reconnected 
the sessions, so the CInode won't have any client cap. So when trimming 
the straydn and CInode, the CInode will be put into the purge queue.

4, After up:reconnect, when retrying the getattr requests the MDS will 
return ESTALE.

This should be fixed in https://github.com/ceph/ceph/pull/41667 
recently, it will just enables trim() in up:active state.

I also went through the ESTALE related code in MDS, this patch still 
makes sense and when getting an ESTALE errno to retry the request make 
no sense.

BRs

Xiubo


