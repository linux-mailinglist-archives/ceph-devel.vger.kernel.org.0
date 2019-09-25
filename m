Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F44BE81C
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Sep 2019 00:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbfIYWKl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Sep 2019 18:10:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51117 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727356AbfIYWKl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 Sep 2019 18:10:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569449439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4FQhVVM1l2BEk49qslRTmBjpuQNnyv04u3wbYB9SsbU=;
        b=ev0tiV8E16ADHxTz83AnMqs36bJy3NehA8w1Wzw5wsJWR2ljZwvO1M5NXw1CWe9gHLlIra
        JcVnxGy7O6Vgi2dtIE4b+CZAOjMemghVFzAX9rVaSRwOTMiUE6noiHrhdfWYouWVV3KxgC
        7zOHr+kFVr1aJzM/Ma51GXjO+J8b+NQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-kHLw-i0UPUy0t0zG_RvoJg-1; Wed, 25 Sep 2019 18:10:37 -0400
Received: by mail-qt1-f198.google.com with SMTP id e13so383788qto.18
        for <ceph-devel@vger.kernel.org>; Wed, 25 Sep 2019 15:10:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4FQhVVM1l2BEk49qslRTmBjpuQNnyv04u3wbYB9SsbU=;
        b=kcN40hRM217a1WmZnjKhehXvtVdYNmDRoN0moBjP2Jg9OxEnsEKH/llKaQi1CXP/0I
         LmUZkKGqNHLOXsAxD5+0MLQ3fDsscrzgejz2tCT4ihaSV0kwnr5qxJVN42QXOq7E+Os1
         7EZoHM8L9paoiQQPykxzCJUleYGlZuxoXI4cpO66jZAcE0TwCGNB998iCE2yTPo3bmtB
         cCel1YuWhTAFOCcUjjWV7FgrynQ0f5Vwg+vTxNalp0Vhu9KqBEAsi1+cJB7bejFYJ5uV
         xwjcZyiT3DGDeWSa9byfDy+RAwTmsQhESKShLxrvQjHYtY5ya8vkzN4mMo94ddb9jilP
         BaGQ==
X-Gm-Message-State: APjAAAVGSXNqPrc0r1GOxGyG+ghfzPiCQ1Ko9xFIOLNJrwUAXkF3Fh7h
        N9aKrN0sWPMGOlrILMs34qgqtuz9QHR8Jtq9uAybVrXOE9PtNo+2LCuCI7kKwYj1L124MoV+0fI
        D2jSSW1Ymm2l84U9Ci3SvPKmEc1JNX7wfew4nEw==
X-Received: by 2002:ac8:1bcb:: with SMTP id m11mr795092qtk.122.1569449436434;
        Wed, 25 Sep 2019 15:10:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwyfybyX3r4qqNk+zZN/PCisMZlbUhaH1nlSLH3Q3l34TsGH8aV+X/dhRQQrFyvZ6rjjIHY3BbLkilvg7I3J3c=
X-Received: by 2002:ac8:1bcb:: with SMTP id m11mr795065qtk.122.1569449436234;
 Wed, 25 Sep 2019 15:10:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAC-Np1zTk1G-LF3eJiqzSF8SS=h=Jrr261C4vHdgmmwcqhUeXQ@mail.gmail.com>
 <CAC-Np1zjZJW2iqLVe720u_sxQDTKjoUqL9ftrqKbMcYbZQgYFQ@mail.gmail.com>
 <CALi_L4_Sz8oFHAFyRfqDfLWGRJSHnSd=dyYUZ6P92o8VY3vGCQ@mail.gmail.com>
 <CALqRxCygXUzA0+4sY6meMO9Smq2rouei7ay0BqJD9+-du7RCYQ@mail.gmail.com>
 <CAN-GepKyROe6CRmKFjFyMvH8b5AGPomh96Q6gRVzQS-Zv-iDtQ@mail.gmail.com>
 <CAA6-MF_OwcHjDTM=48_pbPbp8BPf0Dd+iLTWZ+06E8akKoMxGA@mail.gmail.com> <CALi_L4-QGFaKhRSNUMcC+CfNnh8rBR_A8PBkVqDydSEX5ho7Ag@mail.gmail.com>
In-Reply-To: <CALi_L4-QGFaKhRSNUMcC+CfNnh8rBR_A8PBkVqDydSEX5ho7Ag@mail.gmail.com>
From:   Ken Dreyer <kdreyer@redhat.com>
Date:   Wed, 25 Sep 2019 16:10:25 -0600
Message-ID: <CALqRxCw3Z2HHfszEizVtNbd2f22antp-2CbRpehUVTMO0b3FKw@mail.gmail.com>
Subject: Re: [ceph-users] Re: download.ceph.com repository changes
To:     Sasha Litvak <alexander.v.litvak@gmail.com>
Cc:     Janne Johansson <icepic.dz@gmail.com>,
        Unknown <ceph-maintainers@ceph.com>,
        ceph-users <ceph-users@ceph.io>,
        ceph-devel <ceph-devel@vger.kernel.org>
X-MC-Unique: kHLw-i0UPUy0t0zG_RvoJg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 25, 2019 at 1:56 PM Sasha Litvak
<alexander.v.litvak@gmail.com> wrote:
>
> I guess for me the more crucial  questions should be answered:
>

> 1.  How can a busted release be taken out of repos (some metadata
> update I hope)?

It's hard to define the word "busted" in a way that satisfies everyone.

For example, in the past, we've heard rumors that the releases are
"busted" and we need to pull them, and in reality the impact turned out
to be way smaller than expected. If we let panic reign, we would have
builds appearing and disappearing quite often.

Or to borrow a real example, what happens when the new (buggy) release
fixes a CVE, and we coordinated the disclosure of the CVE to happen on
release day? Then we're hurting some users to help others.

> 2.  Can some fix(es) be added into a test release so they can be
> accessed by community and tested  / used before next general release
> is avaialble.  I was thinking about trying to pick some critical
> backports for internal build / testing but it is not very simple for
> everyone.  It seems that shaman has some test builds going on, so may
> be if a track issue will mention that build xxxyz contains fixes for
> ticket 9999 "for testing purposes only use at your peril", it will
> allow the community to test the build and for someone who in need to
> get to the higher ground quickly.

There's certainly more to explore here. Maybe we need a defined release
criteria so things are less subjective. Or maybe increasing the
frequency and decreasing the size of releases will help. I'm interested
in lowering the barriers for contributors to test early and often so
our cutting-edge users get their builds fast and our more conservative
users get something more stable.

