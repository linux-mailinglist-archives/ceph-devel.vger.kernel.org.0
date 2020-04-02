Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6879D19C684
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Apr 2020 17:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389392AbgDBPyU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Apr 2020 11:54:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26846 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388677AbgDBPyU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Apr 2020 11:54:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585842859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BEpjRxqeEHvLMsy9Gp9PdIiBjw4rI/rQY4bpu/yx82U=;
        b=P7SG3Ix6Kk93gc43PtDIC48rGgqAOg8QnIb4kiiqkE2+ZgM4AkcrXzfBiVMZZ+VVrTlXX8
        /IamViTWlD7huBF1uVrFJLBmXj1XbLe+TkuL/YYteIiGnJkwMY53RrIxygWduL+zNvol/X
        5IG3qTk98UpGTf8Y4WAV8vkIa7PTKds=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-iUKfVvC7NG6kMBjg6UWJAg-1; Thu, 02 Apr 2020 11:54:14 -0400
X-MC-Unique: iUKfVvC7NG6kMBjg6UWJAg-1
Received: by mail-qk1-f199.google.com with SMTP id c1so3405641qkg.21
        for <ceph-devel@vger.kernel.org>; Thu, 02 Apr 2020 08:54:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BEpjRxqeEHvLMsy9Gp9PdIiBjw4rI/rQY4bpu/yx82U=;
        b=OlVgCsFvFrBUdv/QYKD0dbxecelRNW+VgGu4Z78BTmy+GQu/vMnY2oqUCAmg4bYvGa
         8EC2xKhoGXO2yr1fgsN9trOMkrDe0cHbVzgMqVw0BVtOjq1BOonbC1kokwDr9R/1VcYY
         XQ2MF7X/VQVBUdjRTrncCTeAgAGyC/WDBhPqemCAcuq5/16rR7CzS4qHbnyHuZCWc7Zc
         laKvaiSwWLyQeHonODzPCqkxZO8t+y5w8IiyrVXr5gUCKen94TjNWxX+jzgq3FNxNiEK
         TKneM1iaEjP7uYiTSwemal89WXUvBE9WO4MeL5epR7luwCsFHZazzdT3qooN2pFiKqeH
         tsVg==
X-Gm-Message-State: AGi0PuZwawElJIKTpCBv9a0SH0uTgfBucHKVRvPeEgoPhbZK2OyaX281
        zeQxZahoSaw2aTb6yxdWJ/LWeo+/z/LNP47+rsRGUwj8l+i6fEbJj1B3XeSz6sbLzWllmbv2wnZ
        AdbgYsMvb84Hrp/LEYnOy7UsZoobw3k19/SOrdA==
X-Received: by 2002:ac8:1941:: with SMTP id g1mr3663224qtk.70.1585842853934;
        Thu, 02 Apr 2020 08:54:13 -0700 (PDT)
X-Google-Smtp-Source: APiQypKcTzKGgo+GD9CRBPEybT08TiKa7msA+f/v0VU6oD9b8REgix2in0ki6fO3LiBURfBDE8t7PuwoAvIg5MnzDCQ=
X-Received: by 2002:ac8:1941:: with SMTP id g1mr3663180qtk.70.1585842853413;
 Thu, 02 Apr 2020 08:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200402112911.17023-1-jlayton@kernel.org>
In-Reply-To: <20200402112911.17023-1-jlayton@kernel.org>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Thu, 2 Apr 2020 08:54:02 -0700
Message-ID: <CAJ4mKGY_1vtbaM-m+X7yKE-vFDorWi9E+RNbPi-z5bcXkdXQYw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ceph: fix long stalls on sync/syncfs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Weil, Sage" <sage@redhat.com>, Jan Fajerski <jfajerski@suse.com>,
        Luis Henriques <lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Didn't look at the code too hard, but this sounds good to me.

I also realized that the userspace client isn't quite complete because
it didn't send out FLAG_SYNC on a per-MDS-session basis, just for the
last cap in its global dirty list. So thanks for that. :)
https://tracker.ceph.com/issues/44916

On Thu, Apr 2, 2020 at 4:29 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> This is v2 of the patch I sent the other day to fix the problem of long
> stalls when calling sync or syncfs.
>
> This set converts the mdsc->cap_dirty list to a per-session list, and
> then has the only caller that looks at cap_dirty walk the list of
> sessions and issue flushes for each session in turn.
>
> With this, we can use an empty s_cap_dirty list as an indicator that the
> cap flush is the last one going to the session and can mark that one as
> one we're waiting on so the MDS can expedite it.
>
> This also attempts to clarify some of the locking around s_cap_dirty,
> and adds a FIXME comment to raise the question about locking around
> s_cap_flushing.
>
> Jeff Layton (2):
>   ceph: convert mdsc->cap_dirty to a per-session list
>   ceph: request expedited service on session's last cap flush
>
>  fs/ceph/caps.c       | 72 +++++++++++++++++++++++++++++++++++++++-----
>  fs/ceph/mds_client.c |  2 +-
>  fs/ceph/mds_client.h |  5 +--
>  fs/ceph/super.h      | 21 +++++++++++--
>  4 files changed, 87 insertions(+), 13 deletions(-)
>
> --
> 2.25.1
>

