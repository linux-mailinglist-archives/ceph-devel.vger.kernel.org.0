Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382AD3759B6
	for <lists+ceph-devel@lfdr.de>; Thu,  6 May 2021 19:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbhEFRwv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 May 2021 13:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236307AbhEFRwu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 May 2021 13:52:50 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F85C061761
        for <ceph-devel@vger.kernel.org>; Thu,  6 May 2021 10:51:52 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id a36so8150024ljq.8
        for <ceph-devel@vger.kernel.org>; Thu, 06 May 2021 10:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tz9CyNHlTYlgYPLN7fAWYM+2mWJStrWfSD9j5wuxyg4=;
        b=ebP3CT9ifwaFJPDmHk5AT9swfP7XAAdoLic3YkHtLW2P2D6QLx0RlbCgSO6qKDDD/c
         sG6cTaSoc0VGes0VQkcQxTt0D3a+CVjnpDqxW224K77CheDjpbWK2OTM7pNU+cFDmbp/
         51fCFed8e6C5mMXhHuPiEJ1o17bu+Vshii/n8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tz9CyNHlTYlgYPLN7fAWYM+2mWJStrWfSD9j5wuxyg4=;
        b=CP99+9+KznUygG+tgbA8WvaOw+5D6cTBgJaMxDqGBKod/7DlNiIvMCpjVazK8Yww0N
         2JVL9G8gHIOYIBDjbYGwbQNs/ZkKd8i2Hy9hUXH+qBjdAq9yffY2VzOEpgI22ByUwEEe
         RyuHfADBF3PBSC0c0kW5oyeDAdlbb9A7HKSCi7lh4JoOXgZhpp2WVu/wNToVO5/XSguT
         8kx8/GKgSgizrrRk62aiHxCcyvXQJU4VHJ5MmASFxJYwFG9yOoxjJtckudtz9gwaF1Xs
         dg8BBuRyrt6nywF02Q0rafqPsPoSENxl3rg6ksAhfDRcmR/V5rLBKsU9iUudhneBuSRv
         jHRg==
X-Gm-Message-State: AOAM533nLJ2Qs7YQHBSfK4B3w4eYJcjQL1KaVWmfpu8r6EyvbB1YLutO
        i3Oo5G8sV5M+8CAk6rhuW8WEnpFy6IfksiGuiqM=
X-Google-Smtp-Source: ABdhPJwdiYc3bUN8zym9ugT2EGPXHrsq+phLdYugEQfUv/Wvn4Zq8V4c1ygUcCfAxAevoxaTOpJbWA==
X-Received: by 2002:a2e:a0c7:: with SMTP id f7mr4553019ljm.13.1620323510419;
        Thu, 06 May 2021 10:51:50 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id v20sm817522lfd.92.2021.05.06.10.51.49
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 10:51:49 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id u20so8124067lja.13
        for <ceph-devel@vger.kernel.org>; Thu, 06 May 2021 10:51:49 -0700 (PDT)
X-Received: by 2002:a05:651c:333:: with SMTP id b19mr4360748ljp.61.1620323509360;
 Thu, 06 May 2021 10:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210506143312.22281-1-idryomov@gmail.com>
In-Reply-To: <20210506143312.22281-1-idryomov@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 6 May 2021 10:51:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgjQgUYrMD_tTm5M1BqeN5Z7h_z5EkU65RXAnEevsTDLA@mail.gmail.com>
Message-ID: <CAHk-=wgjQgUYrMD_tTm5M1BqeN5Z7h_z5EkU65RXAnEevsTDLA@mail.gmail.com>
Subject: Re: [GIT PULL] Ceph updates for 5.13-rc1
To:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     ceph-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 6, 2021 at 7:33 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> There is a merge conflict in fs/ceph/dir.c because Jeff's inode
> type handling patch went through the vfs tree together with Al's
> inode_wrong_type() helper.  for-linus-merged has the resolution.

Actually, the linux-next resolution looks wrong - or at least
unnecessary - to me.

The conversion to d_splice_alias() means that the IS_ERR() test is now
pointless, because d_splice_alias() handles an error-pointer natively,
and just returns the error back with ERR_CAST().

So the proper resolution seems to be to just drop the IS_ERR().

Adding Jeff and Al just as a heads-up.

           Linus
