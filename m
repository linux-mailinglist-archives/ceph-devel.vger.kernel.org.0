Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C50731B3D2
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Feb 2021 02:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhBOBCg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 14 Feb 2021 20:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhBOBCg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 14 Feb 2021 20:02:36 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A6CC061574
        for <ceph-devel@vger.kernel.org>; Sun, 14 Feb 2021 17:01:55 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id p21so7746981lfu.11
        for <ceph-devel@vger.kernel.org>; Sun, 14 Feb 2021 17:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8oLEqXUvdqy1QH/cRggvF58640ngzAUjBT8Tfk3Wjwg=;
        b=eb+VDAyVwB6RZ6vXNDSIXjjY5/KGJonBZpcw4InpSNpoqcKC9wCYBknhMsgf9sPklg
         GzCvnbIRKgTg7gtA7teRfKAGGFk9BR9qw3HHsG7GJ3+trFjsmHXqEUXRQMhyaGXIHFPG
         +BYG0bBsO6r2Y7DOTssLQQLnPqsDN5e1ysQAo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8oLEqXUvdqy1QH/cRggvF58640ngzAUjBT8Tfk3Wjwg=;
        b=mZ/pODR9/Z/wUNxmHp+f4NSy59HRju96PswZCl9dOeEqqb8+wO5VrYPOQ38fKYZb1Z
         mizAT+tAEBk66yt8a+R2zSleuOKhejuAlwTbTY81997DjsnqXfR+++EB9nVBs5uPzJSq
         ZYb7trq0A3zsc4dtnM7NzO3EvXbhR4QyXHK6ezERfbBPHREvsSIH7PI8K1ag6I94mHpB
         ys5/tmwEMIVDMwkEOwc2OkW0Onh964Gbld0KVLy3xpsUiqtT7pBypaMFmUHWSwsf1tCi
         hVwZXXT3f5Y5tPIgm73kcbpSAv1ABNp+dbeyFwe7bekiSZ9zbv9PENSdUKLwTZLNF49X
         32cA==
X-Gm-Message-State: AOAM532J2H0MLFUMxNauvkZTIUJgtfgl1KZ/Xf+AxaDukvLk+POxUNd3
        Vuw94OdpZPQI1wX5cm2Hep5ZxKc0N9Th+w==
X-Google-Smtp-Source: ABdhPJyC0HCEMM30sSZabhFi49qU4XDJInoR9ttf49GxGgn0Jz+rP5EPVJrTmc0qi15XBr53QLi0sA==
X-Received: by 2002:ac2:4477:: with SMTP id y23mr7151116lfl.234.1613350913465;
        Sun, 14 Feb 2021 17:01:53 -0800 (PST)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id u12sm2627196lff.250.2021.02.14.17.01.52
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 17:01:52 -0800 (PST)
Received: by mail-lj1-f173.google.com with SMTP id a17so5938409ljq.2
        for <ceph-devel@vger.kernel.org>; Sun, 14 Feb 2021 17:01:52 -0800 (PST)
X-Received: by 2002:a05:651c:112:: with SMTP id a18mr8181174ljb.465.1613350911576;
 Sun, 14 Feb 2021 17:01:51 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wj-k86FOqAVQ4ScnBkX3YEKuMzqTEB2vixdHgovJpHc9w@mail.gmail.com>
 <591237.1612886997@warthog.procyon.org.uk> <1330473.1612974547@warthog.procyon.org.uk>
 <1330751.1612974783@warthog.procyon.org.uk> <CAHk-=wjgA-74ddehziVk=XAEMTKswPu1Yw4uaro1R3ibs27ztw@mail.gmail.com>
 <27816.1613085646@warthog.procyon.org.uk> <CAHk-=wi68OpbwBm6RCodhNUyg6x8N7vi5ufjRtosQSPy_EYqLA@mail.gmail.com>
 <860729.1613348577@warthog.procyon.org.uk>
In-Reply-To: <860729.1613348577@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 14 Feb 2021 17:01:35 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh7xY3UF7zEc0BNVNjOox59jYBW-Gfi7=emm+BXPWc6nQ@mail.gmail.com>
Message-ID: <CAHk-=wh7xY3UF7zEc0BNVNjOox59jYBW-Gfi7=emm+BXPWc6nQ@mail.gmail.com>
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

On Sun, Feb 14, 2021 at 4:23 PM David Howells <dhowells@redhat.com> wrote:
>
> Anyway, I have posted my fscache modernisation patches multiple times for
> public review, I have tried to involve the wider community in aspects of the
> development on public mailing lists and I have been including the maintainers
> in to/cc.

So then add those links and the cc's to the commit logs, so that I can
*see* them.

I'm done with this discussion.

If I see a pull request from you, I DO NOT WANT TO HAVE TO HAVE A
WEEK-LONG EMAIL THREAD ABOUT HOW I CANNOT SEE THAT IT HAS EVER SEEN
ANY REVIEW.

So if all I see is "Signed-off-by:" from you, I will promptly throw
that pull request into the garbage, because it's just not worth my
time to try to have to get you kicking and screaming to show that
others have been involved.

Can you not understand that?

When I get that pull request, I need to see that yes, this has been
reviewed, people have been involved, and yes, it's been in linux-next.

I want to see "reviewed-by" and "tested-by", I want to see "cc", and I
want to see links to submission threads with discussion showing that
others actually were involved.

I do *not* want to see just a single signed-off-by line from you, and
then have to ask for "has anybody else actually seen this and reviewed
it".

Look, here's an entirely unrelated example from a single fairly recent
trivial one-liner memory leak fix:

    Fixes: 87c715dcde63 ("scsi: scsi_debug: Add per_host_store option")
    Link: https://lore.kernel.org/r/20210208111734.34034-1-mlombard@redhat.com
    Acked-by: Douglas Gilbert <dgilbert@interlog.com>
    Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

that's from a quite a trivial commit. Yes, it's trivial, but it could
still be wrong, of course. And if somebody ever reports that it causes
problems despite how simple it was, look at what I have: I have three
people to contact, and I have a pointer to the actual original
submission of the patch.

Do we have that for all our commits? No. But it's also not at all
unusual any more, and in fact many commits have even more, with
testing etc.

And yes, sometimes the test results and acks come back later after
you've already pushed the changes out etc, and no, it's generally not
worth rebasing for that - maybe others have now started to rely on
whatever public branch you have. Which is why the "Link:" is useful,
so that if things come in later, the discussion can still be found.
But quite often, you shouldn't have pushed out some final branch
before you've gotten at least *some* positive response from people, so
I do kind of expect some "Acked-by" etc in the commit itself.

THAT is what you need to aim for.

And yes, I'm picking on you. Because we've had this problem before.
I've complained when you've sent me pull requests that don't even
build, that you in fact had been told by linux-next didn't build, and
you still sent them to me.

And as a result, I've asked for more involvement from other people before.

So now I'm clarifying that requirement - I  absolutely need to see
that it has actually seen testing, that it has seen other people being
involved, and that it isn't just you throwing spaghetti at the wall to
see what sticks.

And I'm not going to do that for every pull request. I want to see
that data *in* the pull request itself.

            Linus
