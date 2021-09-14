Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7358040B472
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhINQXg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 12:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhINQXf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 14 Sep 2021 12:23:35 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A84C061764
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 09:22:17 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id w4so24937837ljh.13
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 09:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3dYD2uKNORcxZ6YMCdwcOxjjHXEclNcfa/CTjAP47gc=;
        b=aWJRDZPRQV27jEUKoc4qE6zGbRoWbKwm9kcYSPpoNuqjBLGs9WKOvCqbYQZ04P3jy1
         4wsAum1KxojNT2yyO1DmteAlpzy+vIjQ6bjIvwLNB76bbbmj19VrvzgTZnYd6uwWG6vX
         yWKNOrbr5bi7cuk7kXat3qOTmWTGGPHSlwsBA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3dYD2uKNORcxZ6YMCdwcOxjjHXEclNcfa/CTjAP47gc=;
        b=Grsq5HPw1J0DwKDj0rqEE52OIoT4+yfT5wq8cjlCe8xxgScbJvkKQjRpwGfGbNQhLL
         Eb65nxrH5NGRhtDot8VJ+svw1Eu+WC6ymcM8IuvVgINpTDuXAKgcumZGPgdtdbslmyrN
         aZdwk/hzyR1Dr4a76y0Grp3H2Y1wNZNjJU7BxRI0QNY28f87vLaPLhxu9OnCFGVSD7at
         DjcuhZlT5jNPx2R++zgIk6tl2b1ncxr+TGopX0q949iWMG/a6tPdRMTvMKKD1YNq1IZj
         XZ30abLbqPXYFC/nLkJ7kHAKt3Pa84TQzV93Uh35EfzIVbwVZOGlYMe+DwAYM0u5HLbE
         SA6w==
X-Gm-Message-State: AOAM533f9tLfLLbZ9z9H6IbvU1VQiFn3qLfDOOLz1bupHoDBak1W5OEX
        rf9bBZe4ITILZ6SD63yWMTNKwiuM8tVSmkm2Ymo=
X-Google-Smtp-Source: ABdhPJx24LGZMq1CTDM5aQsJUqBbilfsrGq0PPjDChMhQlHk/AfPmGMNNUELdkCLdPUTIloFhNZFyg==
X-Received: by 2002:a2e:1559:: with SMTP id 25mr3767041ljv.529.1631636535177;
        Tue, 14 Sep 2021 09:22:15 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id q20sm304945lji.21.2021.09.14.09.22.14
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 09:22:14 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id i7so13875877lfr.13
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 09:22:14 -0700 (PDT)
X-Received: by 2002:a05:6512:3da5:: with SMTP id k37mr14013881lfv.655.1631636533920;
 Tue, 14 Sep 2021 09:22:13 -0700 (PDT)
MIME-Version: 1.0
References: <163162767601.438332.9017034724960075707.stgit@warthog.procyon.org.uk>
In-Reply-To: <163162767601.438332.9017034724960075707.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Sep 2021 09:21:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiVK+1CyEjW8u71zVPK8msea=qPpznX35gnX+s8sXnJTg@mail.gmail.com>
Message-ID: <CAHk-=wiVK+1CyEjW8u71zVPK8msea=qPpznX35gnX+s8sXnJTg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] fscache: Replace and remove old I/O API
To:     David Howells <dhowells@redhat.com>
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        v9fs-developer@lists.sourceforge.net,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-cachefs@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Sep 14, 2021 at 6:54 AM David Howells <dhowells@redhat.com> wrote:
>
>  (1) A simple fallback API is added that can read or write a single page
>      synchronously.  The functions for this have "deprecated" in their names
>      as they have to be removed at some point.

I'm looking at those patches, and there's no way I'll apply anything
that starts out with moving to a "deprecated" interface.

Call it "fallback" or "simple" or something that shows the intent, but
no, I'm not taking patches that introduce a _new_ interface and call
it "deprecated".

            Linus
