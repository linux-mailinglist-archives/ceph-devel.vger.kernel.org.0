Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24B63156B6
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Feb 2021 20:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhBITUd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Feb 2021 14:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbhBITIA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Feb 2021 14:08:00 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834D8C06121E
        for <ceph-devel@vger.kernel.org>; Tue,  9 Feb 2021 11:07:01 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id q14so14143636ljp.4
        for <ceph-devel@vger.kernel.org>; Tue, 09 Feb 2021 11:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1tHDrQ7k7QBExa6hxOU6qMztojmSPjc893LQ4fde7dg=;
        b=akIN38EhQAi1EJYSeLBzpY86D4HcP1JFpL9GOZ+0RTnCkorkEfcVrIAVKTL3jMnG1S
         wB2qolfwaFv21H7u2zEEkvnFpGX1nEHeJ1S4J1sfz5c5YnXEdHBQ4kH64G0jT9/l9/e6
         eD4OPnbfiSTjG9KsSbeEkIcjaKRrzYZYK/x80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1tHDrQ7k7QBExa6hxOU6qMztojmSPjc893LQ4fde7dg=;
        b=ZN30TMEibzLz3nKmO83/Z8G+CF/bnRO7gljxw0Z+oBv5lH10oX+YGP3yidchr4sues
         EDMmR+zO74h8SIBxx7VDC8tzzkituJfThkBeeSBwyZFL1LvUbrER4YmYVyT1C8Jx7KmO
         bmZJU8EagtB8R55c6+JXSBJ08Wbmi177c61uqa/kCdqaYIIoEHgPOZbt33j4MQVZnxOT
         HfKOX3rfduNqZTDCzyWM3F70NhCbf87V342onwUTsmUJDrUDnycIeQY/plgo981Pv8ga
         3e635dRaY5IQvAY0pd6jq+gWDFRc2GGDxRdPmuE7TDAB0ePSM8Tnz/YjkxRgAe4sWrd+
         Y9NQ==
X-Gm-Message-State: AOAM531RoesIJUrLLUDT3D6+e6wQ9lcy37+L/m4bUHQ11QTNSMuY0luy
        ZtnpzPVjDCAN7QTaTWxYEyQBAOpl+0VXWg==
X-Google-Smtp-Source: ABdhPJyOjvPA6j2MTWY3Lh3xHogcYodWIEBggwrluRNcH9dPUFzlO6chtM1mDVqWz7vBvQwhR3WK/w==
X-Received: by 2002:a2e:9cd5:: with SMTP id g21mr7356959ljj.383.1612897619192;
        Tue, 09 Feb 2021 11:06:59 -0800 (PST)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id i25sm2650363ljj.100.2021.02.09.11.06.57
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 11:06:57 -0800 (PST)
Received: by mail-lf1-f51.google.com with SMTP id d3so29981530lfg.10
        for <ceph-devel@vger.kernel.org>; Tue, 09 Feb 2021 11:06:57 -0800 (PST)
X-Received: by 2002:a19:c14c:: with SMTP id r73mr13646015lff.201.1612897616810;
 Tue, 09 Feb 2021 11:06:56 -0800 (PST)
MIME-Version: 1.0
References: <591237.1612886997@warthog.procyon.org.uk>
In-Reply-To: <591237.1612886997@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Feb 2021 11:06:41 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj-k86FOqAVQ4ScnBkX3YEKuMzqTEB2vixdHgovJpHc9w@mail.gmail.com>
Message-ID: <CAHk-=wj-k86FOqAVQ4ScnBkX3YEKuMzqTEB2vixdHgovJpHc9w@mail.gmail.com>
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

So I'm looking at this early, because I have more time now than I will
have during the merge window, and honestly, your pull requests have
been problematic in the past.

The PG_fscache bit waiting functions are completely crazy. The comment
about "this will wake up others" is actively wrong, and the waiting
function looks insane, because you're mixing the two names for
"fscache" which makes the code look totally incomprehensible. Why
would we wait for PF_fscache, when PG_private_2 was set? Yes, I know
why, but the code looks entirely nonsensical.

So just looking at the support infrastructure changes, I get a big "Hmm".

But the thing that makes me go "No, I won't pull this", is that it has
all the same hallmark signs of trouble that I've complained about
before: I see absolutely zero sign of "this has more developers
involved".

There's not a single ack from a VM person for the VM changes. There's
no sign that this isn't yet another "David Howells went off alone and
did something that absolutely nobody else cared about".

See my problem? I need to be convinced that this makes sense outside
of your world, and it's not yet another thing that will cause problems
down the line because nobody else really ever used it or cared about
it until we hit a snag.

                  Linus
