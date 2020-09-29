Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E73B27BF5D
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Sep 2020 10:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbgI2I2W (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Sep 2020 04:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI2I2W (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Sep 2020 04:28:22 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A46FC061755
        for <ceph-devel@vger.kernel.org>; Tue, 29 Sep 2020 01:28:22 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id z5so4032227ilq.5
        for <ceph-devel@vger.kernel.org>; Tue, 29 Sep 2020 01:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3xSg2U1EULP7Xrvc+rm9VZZdV5JzMqf2aW13czezQ48=;
        b=V45EAAfkrC8/r1bMRbM0d9WylifZSwkW7Ki3PANO2vsDV6VCZE7t5q1JLaWoCIK+nk
         3qfCxkonYdev/x34ySZkG+KmAXFcov9tZSl2GNT+Pur97HtmXkV6hQhDo4qMEEedVjJH
         6Gu930TtEWLyVtdruZ+KuOVJ4i7FLAalwkipzT4v81UIyiU8JMuxIgl8iVt0BvYAWm6j
         TGFPGdHAXuoaAjTTlPjH0B9eXNZIRoeUP+HyGOhe3Y6A3mnpoVGwKAG4gX3Vx4Yat22p
         S7tdGkx6+142ZOd60lZ0f0gu/810HgU7xikRrCSKDXGq8wpoUSPp8UyT1W00E0hgnj8s
         BdwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3xSg2U1EULP7Xrvc+rm9VZZdV5JzMqf2aW13czezQ48=;
        b=X6yHMTltJrlIv5NYA8uwKgd5H40JN1qDg0IAkx7QNaR4l9/wzG5IFDavcR6mwRitwR
         CagyhdR1QjPxJsy3ZbgtqpbL6fBH38qIphJqcjzwPFw4rXwM4HyxBwkqq/Gvsx3JEtGc
         R+FY5+UiaosgQRgwbqEq2pz7/KSL9Ltt3o5DHHq/9+C+G9jqt0JhwZsFLDYkR1/em7jM
         YDwX8BWPmZ3X2iZnCucogXoPeDIe1CirG56olknqPh4cVDfAcZ39ZkXIhxqhT/Ng5aGD
         dVYjVwKUjHomQSZ+n1LqwLQepp6MLOjIWxsggefzED4TZVQ+YL2VYMZkjJHmCA3LeMyE
         lLfA==
X-Gm-Message-State: AOAM531RT1NV6Nw/KsDsc8KPtWH5jBDLKc5bi8yfTwilqLcT1J7bWUZC
        bj5L4MoZoae8F0WQRoAfh38ZlJVJDg+D1MRuw6U=
X-Google-Smtp-Source: ABdhPJw0HWwMHNuI8DjhiQ4TD5pnRHFS+kT6ngjIRFbdHmd03qyfHNMcnub/ieYKtMhwv4XdIWJOGdkYAN2YA5eo52s=
X-Received: by 2002:a92:360d:: with SMTP id d13mr1844712ila.99.1601368102040;
 Tue, 29 Sep 2020 01:28:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200925140851.320673-1-jlayton@kernel.org>
In-Reply-To: <20200925140851.320673-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 29 Sep 2020 16:28:10 +0800
Message-ID: <CAAM7YAmJfNCbt4ON5c44FFVYOUhXu0ipK858aLJK22ZX2E-FdA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] ceph: fix spurious recover_session=clean errors
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Sep 25, 2020 at 10:08 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Ilya noticed that he would get spurious EACCES errors on calls done just
> after blocklisting the client on mounts with recover_session=clean. The
> session would get marked as REJECTED and that caused in-flight calls to
> die with EACCES. This patchset seems to smooth over the problem, but I'm
> not fully convinced it's the right approach.
>

the root is cause is that client does not recover session instantly
after getting rejected by mds. Before session gets recovered, client
continues to return error.


> The potential issue I see is that the client could take cap references to
> do a call on a session that has been blocklisted. We then queue the
> message and reestablish the session, but we may not have been granted
> the same caps by the MDS at that point.
>
> If this is a problem, then we probably need to rework it so that we
> return a distinct error code in this situation and have the upper layers
> issue a completely new mds request (with new cap refs, etc.)
>
> Obviously, that's a much more invasive approach though, so it would be
> nice to avoid that if this would suffice.
>
> Jeff Layton (4):
>   ceph: don't WARN when removing caps due to blocklisting
>   ceph: don't mark mount as SHUTDOWN when recovering session
>   ceph: remove timeout on allowing reconnect after blocklisting
>   ceph: queue request when CLEANRECOVER is set
>
>  fs/ceph/caps.c       |  2 +-
>  fs/ceph/mds_client.c | 10 ++++------
>  fs/ceph/super.c      | 13 +++++++++----
>  fs/ceph/super.h      |  1 -
>  4 files changed, 14 insertions(+), 12 deletions(-)
>
> --
> 2.26.2
>
