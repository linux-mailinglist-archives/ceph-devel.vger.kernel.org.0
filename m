Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B83B31A94C
	for <lists+ceph-devel@lfdr.de>; Sat, 13 Feb 2021 02:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhBMBHV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 12 Feb 2021 20:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbhBMBHK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 12 Feb 2021 20:07:10 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC811C061223
        for <ceph-devel@vger.kernel.org>; Fri, 12 Feb 2021 17:06:07 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id x1so1142735ljj.11
        for <ceph-devel@vger.kernel.org>; Fri, 12 Feb 2021 17:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L6jTxP9hlbcUR9+3iPNQ9HmsqF25QNS6zvjTzXBH5E4=;
        b=WUNxTILAYi3Kk+wVUIaUVhIr3oaiaHaDjKr023ekUsCD6VQNr+/uPlhMEL6q29t3EB
         7gNdhrTjI0bG4chV1tfJBSEWmnvTFlDxKHjMtcZld38+fszGfI/ow6zlOY5oPPFVrq11
         U9kc9/PviiJUNwLPvQe5fwcbGhKWs2MNkDWS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L6jTxP9hlbcUR9+3iPNQ9HmsqF25QNS6zvjTzXBH5E4=;
        b=XYukFlq0GeHC2ApwhqNmfywW1NXq54rZp9m2K2jie218E8MUW+LYmGL6DFv6E0+C0H
         UXV8ZPAd1zGwjqfgLh2e+CYbQ87bTwEGQP8mwR1Cc9KbD0jcf36U5aN34iN8sueVhlOG
         7RqL7iz2IryE3py4eKFLWX3RZRF/A/G/ZxepcL+Lq+33UPYJG51+SuteJ3oyPtLYohiC
         4Nhh/yA5eFFYQ591i8N8B2YSIP5X9H9De1krFqtA3MZY+k6KBJonhqO17e2QfI2gmHMP
         DmlsruAv2clST0uQUrmtfOqhuOhJHKpQOWtlYUm6sVDEfAbcXZHcmOulyd7KgPgFfY98
         Cuqg==
X-Gm-Message-State: AOAM532pZoXWdxbOUEYxVJjjP5pnudoGVNPlxzVo7cVmxwkxgLr9Pqk/
        Le6Hi/2NP8MEsPifI+7wfz5CzuVePWD7Xg==
X-Google-Smtp-Source: ABdhPJyZCEbmTIRoFZTGB9iZPMmBG1TDPIOygkUt14iD2mIPAK4i5kELwoHPVQCK5ocV5lDo4/OI4g==
X-Received: by 2002:a2e:7f04:: with SMTP id a4mr2949883ljd.3.1613178366167;
        Fri, 12 Feb 2021 17:06:06 -0800 (PST)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id v21sm1898278ljk.122.2021.02.12.17.06.04
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 17:06:04 -0800 (PST)
Received: by mail-lj1-f169.google.com with SMTP id q14so1190917ljp.4
        for <ceph-devel@vger.kernel.org>; Fri, 12 Feb 2021 17:06:04 -0800 (PST)
X-Received: by 2002:a2e:8049:: with SMTP id p9mr3052102ljg.411.1613178363694;
 Fri, 12 Feb 2021 17:06:03 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wj-k86FOqAVQ4ScnBkX3YEKuMzqTEB2vixdHgovJpHc9w@mail.gmail.com>
 <591237.1612886997@warthog.procyon.org.uk> <1330473.1612974547@warthog.procyon.org.uk>
 <1330751.1612974783@warthog.procyon.org.uk> <CAHk-=wjgA-74ddehziVk=XAEMTKswPu1Yw4uaro1R3ibs27ztw@mail.gmail.com>
 <27816.1613085646@warthog.procyon.org.uk>
In-Reply-To: <27816.1613085646@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Feb 2021 17:05:47 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi68OpbwBm6RCodhNUyg6x8N7vi5ufjRtosQSPy_EYqLA@mail.gmail.com>
Message-ID: <CAHk-=wi68OpbwBm6RCodhNUyg6x8N7vi5ufjRtosQSPy_EYqLA@mail.gmail.com>
Subject: Re: [GIT PULL] fscache: I/O API modernisation and netfs helper library
To:     David Howells <dhowells@redhat.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Wysochanski <dwysocha@redhat.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        ceph-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cachefs@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        v9fs-developer@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Feb 11, 2021 at 3:21 PM David Howells <dhowells@redhat.com> wrote:
>
> Most of the development discussion took place on IRC and waving snippets of
> code about in pastebin rather than email - the latency of email is just too
> high.  There's not a great deal I can do about that now as I haven't kept IRC
> logs.  I can do that in future if you want.

No, I really don't.

IRC is fine for discussing ideas about how to solve things.

But no, it's not a replacement for actual code review after the fact.

If you think email has too long latency for review, and can't use
public mailing lists and cc the people who are maintainers, then I
simply don't want your patches.

You need to fix your development model. This whole "I need to get
feedback from whoever still uses irc and is active RIGHT NOW" is not a
valid model. It's fine for brainstorming for possible approaches, and
getting ideas, sure.

               Linus
