Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD3D49BC49
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jan 2022 20:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiAYTln (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jan 2022 14:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiAYTlX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jan 2022 14:41:23 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24014C061744
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jan 2022 11:41:23 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id p15so32985448ejc.7
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jan 2022 11:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vUuc5Cuk4CcGyRt9vUxKg1xmJYyfALSVQcZpRcTgc/o=;
        b=n5zmYAcu5BRy/RslYVij/YtWHYBFXhbyjVK/z+ltADF/rKsfqX05m+Z8DXdR9Jv0Qg
         wLfhBSTv3szp4/htZNlhEQkOcCOt/VKLl7jhF2WVtaFWkV1q6vmOZ7yseOMwfe5eikqc
         g+ILjQHsJOhC5T5SBTBtMBidlMju672lCxKW3oTLGS2l5ZGOj/OpiKicl/hqRDAbSHZc
         9a4LHrleVhQ1RbeSvj5LsUtem57Uq996D9nX6LapPEfH7e2AtRYQKKDRrE9HagxUVGY5
         SzZkZLxOdI+hUdTdVE9cz559+MS15mT52C8tIYjsGMa5Ab1RhL5feeQUF+uJ37t9q2zp
         OTmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vUuc5Cuk4CcGyRt9vUxKg1xmJYyfALSVQcZpRcTgc/o=;
        b=vUDxmISwNrt0kcNawEJMEeJPFJGuQlBEV/sDs+Ti6GNil+DdLXE5rhyDYKA3Z/0fk5
         1wlVa9NKDIfpgf6bvfpD/GgoPNWi1ox11bbCwYabf7lyAGCGJZ2wpLO/m/VGd8rNEh6m
         AWGtTbq74TRKFRzv99diL3XC8l12EjzIa24KYyK9jaN1N/6+nPGXjf4VVg/dIov1YLBr
         0S5qPvqDz63pzIvpWCnr9F+jawyY/FCxvlr0pc9zGQoaqfi+fnrs33S8CK6/XUYG0jzO
         BUJ6/sN0AAqmWxaPl9ic7tzJ7Jyxx3ywT7IhCrqvt/22EwNs1Yf6aVnMpYGFHMiuJLqs
         cHZw==
X-Gm-Message-State: AOAM530XJ7ybCIPeJtNEfHDndFJ+2JCGnwrR9dVXLd3BrieqkVpRBT46
        h7wvvOjODxfATp+hvemk56ZYo7Hd0+SPzjqTpZFu
X-Google-Smtp-Source: ABdhPJxcnmD/6sm65UfWN61wLlYtO0aQst7ytT/b8YLeHTUx5itncRnmoVHeB1qBnaazZQaWShuYhglJDGa42hMl1v0=
X-Received: by 2002:a17:907:1b0d:: with SMTP id mp13mr17172871ejc.29.1643139681609;
 Tue, 25 Jan 2022 11:41:21 -0800 (PST)
MIME-Version: 1.0
References: <CAM2jsSiHK_++SggmRyRbCxZ58hywxeZsJJMJHpQfbAz-5AfJ0g@mail.gmail.com>
 <CAHC9VhR1efuTR_zLLhmOyS4EHT1oHgA1d_StooKXmFf9WGODyA@mail.gmail.com>
 <a77ca75bfb69f527272291b4e6556fc46c37f9df.camel@kernel.org>
 <20220125111350.t2jgmqdvshgr7doi@wittgenstein> <d5490a7c87b8c435b3c7bdb8d2c8edef2c2a576a.camel@kernel.org>
 <20220125121213.ontt4fide32phuzl@wittgenstein> <ab92b28e953601785467cdf8ca67dd5b0ef55105.camel@kernel.org>
 <20220125124920.6dulmlczttifovxy@wittgenstein>
In-Reply-To: <20220125124920.6dulmlczttifovxy@wittgenstein>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 25 Jan 2022 14:41:10 -0500
Message-ID: <CAHC9VhTsJGMvaf=SDp=4vyRoqYVLHsjYYq8pgkzUZ_tFGXKxSw@mail.gmail.com>
Subject: Re: "kernel NULL pointer dereference" crash when attempting a write
To:     Christian Brauner <brauner@kernel.org>,
        linux-security-module@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Stephen Muth <smuth4@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 25, 2022 at 7:49 AM Christian Brauner <brauner@kernel.org> wrote:
> (Btw, it is very odd that the bug in security_fs_context_parse_param()
> still isn't fixed in master. Neither the generic lsm fix:
> https://lore.kernel.org/lkml/018a9bb4-accb-c19a-5b0a-fde22f4bc822@schaufler-ca.com/
> nor the fix for selinux:
> https://lore.kernel.org/lkml/20211012103243.xumzerhvhklqrovj@wittgenstein/
> seem to have gone anywhere? That's another NULL-deref, see:
> https://syzkaller.appspot.com/bug?extid=d1e3b1d92d25abf97943)

Adding the LSM list to the To: line for this snippet to bring these
patches back to front of people's minds.

I suspect the issue is that these patches fall into the general LSM
"security/*.c" bin and as a result don't trigger the individual LSMs
"okay, I'll merge this behavior".  Normally I would expect this to get
picked up by James' LSM tree but sometimes the lines get blurry.

As James is my boss now I talk to him a fair amount, I'll ping him
about these patches to try and get some action on them during this -rc
cycle.  I'll also go review/tag them as well.

-- 
paul moore
paul-moore.com
