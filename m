Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A973546FEC
	for <lists+ceph-devel@lfdr.de>; Sat, 11 Jun 2022 01:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348787AbiFJXUD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jun 2022 19:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347575AbiFJXUC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Jun 2022 19:20:02 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F70F3FB7
        for <ceph-devel@vger.kernel.org>; Fri, 10 Jun 2022 16:19:58 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u12so731858eja.8
        for <ceph-devel@vger.kernel.org>; Fri, 10 Jun 2022 16:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mFUZ/4X/JukFzJtRWCj5IwVqnR0commkjm8Ld9IJoQA=;
        b=AoxxrgfmaiG7fB01rWVX7//fR7hc8pfPaO6KuFkmEJpDpFR/HpqhwLdFQM6dVgzan3
         DB7+Ryy9LWRyARZSjDc1y62fbB3v6E3HNwslaXd4JIbxny9dkIOf8ftYNIIBC41esAeu
         4Gv6sMSeEfJjJ4Ad3imZr/QdI/L/mCWsQLeaA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mFUZ/4X/JukFzJtRWCj5IwVqnR0commkjm8Ld9IJoQA=;
        b=J+C+MXvHHP459OH3jbwm4kEuAdn9RCqalcAUB6aQSEFers7vHX0kzsaMMNoUiTa6jv
         TkQNzbMGUurFNLMyxPjt4ZXI0anRnfE9TyuJL44v+oGu2dMnc3fYkIdK6Tu1hYzCWUO2
         ll1clY9o1g3X3XftMhxrKban8ye71th1mD3VGFuSEuz+zhFcnE9lUQvnAE4IzLgoCoau
         06ko0KCfhj6tucjTgd5bCTCU5/tsYCIDDTN6NP55+2cbdYJRL0iET7KVPtHeHbHRLn+n
         M1F8HwuN7TdDyukBFcG+k87AAiw32X2Vo9OZn+TTFtWBnCyEDbHA6ApdoJKFyCV91aTm
         RDyQ==
X-Gm-Message-State: AOAM531y/MmXgOK8GfeUDFd2hAw9fuFI6SPzbL9ImcrhU5tUCQcOfNRt
        ywy7Rg2GmyXqioo2fzzNwYUHhoWv5yiJx/HB
X-Google-Smtp-Source: ABdhPJxm3dQ0ME0Cjff6fPi3q1UaIuFG31gh0zOozDgNcWt2rhLiLzUHWvYs1rOl6sfMdQ/jSibhnw==
X-Received: by 2002:a17:906:748a:b0:712:2427:3a8 with SMTP id e10-20020a170906748a00b00712242703a8mr3772470ejl.220.1654903197215;
        Fri, 10 Jun 2022 16:19:57 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id p7-20020a170906614700b0070f1b033de4sm180816ejl.200.2022.06.10.16.19.55
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jun 2022 16:19:55 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id a10so193059wmj.5
        for <ceph-devel@vger.kernel.org>; Fri, 10 Jun 2022 16:19:55 -0700 (PDT)
X-Received: by 2002:a05:600c:3485:b0:39c:7db5:f0f7 with SMTP id
 a5-20020a05600c348500b0039c7db5f0f7mr2015707wmq.8.1654903194928; Fri, 10 Jun
 2022 16:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <165489100590.703883.11054313979289027590.stgit@warthog.procyon.org.uk>
In-Reply-To: <165489100590.703883.11054313979289027590.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Jun 2022 16:19:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgeW2nF5MZzmx6cPmS8mbq0kjP+VF5V76LNDLDjJ64hUA@mail.gmail.com>
Message-ID: <CAHk-=wgeW2nF5MZzmx6cPmS8mbq0kjP+VF5V76LNDLDjJ64hUA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] netfs, afs: Cleanups
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        Jeff Layton <jlayton@kernel.org>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-erofs@lists.ozlabs.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 10, 2022 at 12:56 PM David Howells <dhowells@redhat.com> wrote:
>
> Here are some cleanups, one for afs and a couple for netfs:

Pulled,

               Linus
