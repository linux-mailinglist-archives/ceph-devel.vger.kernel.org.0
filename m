Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C013646F1B6
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Dec 2021 18:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237368AbhLIR2z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Dec 2021 12:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242903AbhLIR0s (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Dec 2021 12:26:48 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748C5C0698C4
        for <ceph-devel@vger.kernel.org>; Thu,  9 Dec 2021 09:23:14 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id l25so21941012eda.11
        for <ceph-devel@vger.kernel.org>; Thu, 09 Dec 2021 09:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3tHtN7G3YGgTFoTuLt2UtzoWso0slwegtyye0NyKD6E=;
        b=EkUZICBj3sLfwkSa6PVgwK3UJYMBWKD3Zl6QL503dGClSkUivH631EePhpBTiQgDNd
         VoCL1zBnYteGbjvNrexkMxulvtqSc6W1x7ANtURNimEiRxxY81sHWsZDJM+iJu2oAiti
         SYA5FO15uZ/NSRZ6dw7jltE7xXAi1A4hAYadw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3tHtN7G3YGgTFoTuLt2UtzoWso0slwegtyye0NyKD6E=;
        b=vv+eAR2QU+gU35Y5x1rvQkB1eyn7SFu+ZWKGzpB/e8dSeNKULDYoT7qq8HBVeihb+O
         t826E/Icxm0y41GxH5cP58pjlNPPJpLJTjw66B+h030NBdmZLEnQAZ7SKNYfIwA4F3lv
         2kc/ad5wWwRbKSxopBk4Z75oD6/1O7bAdboCUNISjKcUWfeM/8u4xspz3r9gzLtfvZQR
         +PgnDIQ280Q12WaUlecVmtccyY3kZ/czRcXyrN8EAzZfbRkl5nkxaH0LhX5AXTZkiLyx
         pUxoCqNLxFehMmd7wwc3vL776Q7LWFsRe035iSrqOMvqaZupcqBOY6s0iXupPWspwHvl
         QYxg==
X-Gm-Message-State: AOAM531DFIOoaDh0KdDjo43unDVuvFgXZavz6sNIzFTPjPd1hal06LYo
        G2XeDQpB3T/b6FGsF58rcY+WQoYOgqTMLMOq
X-Google-Smtp-Source: ABdhPJzQ1RIdCvv8tIXgzF4jh83OvX5QnwJX7wlB6dy4u4dDdAwzr3mxMJFpbgP37TWAGofXOgzO2g==
X-Received: by 2002:a17:906:79c3:: with SMTP id m3mr16900936ejo.332.1639070464534;
        Thu, 09 Dec 2021 09:21:04 -0800 (PST)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id ig1sm204575ejc.77.2021.12.09.09.21.04
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 09:21:04 -0800 (PST)
Received: by mail-wm1-f41.google.com with SMTP id 133so4825081wme.0
        for <ceph-devel@vger.kernel.org>; Thu, 09 Dec 2021 09:21:04 -0800 (PST)
X-Received: by 2002:a05:600c:1914:: with SMTP id j20mr8992229wmq.26.1639069994552;
 Thu, 09 Dec 2021 09:13:14 -0800 (PST)
MIME-Version: 1.0
References: <163906878733.143852.5604115678965006622.stgit@warthog.procyon.org.uk>
 <163906888735.143852.10944614318596881429.stgit@warthog.procyon.org.uk>
In-Reply-To: <163906888735.143852.10944614318596881429.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Dec 2021 09:12:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiTquFUu-b5ME=rbGEF8r2Vh1TXGfaZZuXyOutVrgRzfw@mail.gmail.com>
Message-ID: <CAHk-=wiTquFUu-b5ME=rbGEF8r2Vh1TXGfaZZuXyOutVrgRzfw@mail.gmail.com>
Subject: Re: [PATCH v2 07/67] fscache: Implement a hash function
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        JeffleXu <jefflexu@linux.alibaba.com>,
        linux-afs@lists.infradead.org,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Dec 9, 2021 at 8:54 AM David Howells <dhowells@redhat.com> wrote:
>
> Implement a function to generate hashes.  It needs to be stable over time
> and endianness-independent as the hashes will appear on disk in future
> patches.

I'm not actually seeing this being endianness-independent.

Is the input just regular 32-bit data in native word order? Because
then it's not endianness-independent, it's purely that there *is* no
endianness to the data at all and it is purely native data.

So the code may be correct, but the explanation is confusing. There is
absolutely nothing here that is about endianness.

           Linus
