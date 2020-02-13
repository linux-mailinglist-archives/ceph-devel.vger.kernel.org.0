Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2699C15BEF0
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 14:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbgBMNFi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 08:05:38 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33202 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729557AbgBMNFi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Feb 2020 08:05:38 -0500
Received: by mail-qk1-f193.google.com with SMTP id h4so5586359qkm.0
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 05:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m9HWy2iYDhPt+uVkrhsEfnzPb3WxYJKcTtNMf0+hTEk=;
        b=iWd9VKW3HUjfWbz1JLrzHr6H0nbQ/zscspwMg+P8kDIHVa0HOj0fsA5UOmUZHIhrlC
         VwbH05Ak+iKklE9a7yMKgrP6fPac/4b65xip5LoEzbBa0pVGPJ2n3EtlW5PxqVPF38NO
         nj6DZ4yCzqBOM9wUgHNMpXy6Qz+0ZLHm5/hoZb3tBvok2efTXt5J0vFu4zFhUgfkJ/8i
         UhW1Ft3O8pvnZCgtPr1EzcQc7q/WP7PrrnB1w65hJmR/CJnCOZ7GLEKb6MxmQq5/NcJP
         Zm5kOuojYoTFLIk+V7ER+2l8rAVgUAJ6OLyHPIOIHqeqPnvY1Q6kI2uO6c5vlnmyT+qt
         MygQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m9HWy2iYDhPt+uVkrhsEfnzPb3WxYJKcTtNMf0+hTEk=;
        b=Yjq97ydoJy58W3kuCumGa96W+720claTnx4UYrLvTJ02pj3OpgSS7Q2l1idL5Q2Wuo
         FsbRcYTzghHt30WkjWuJoU3VbascnVMZ+0eqzJOqdyT3K0fOl1vvukazkb8LwEXf+Ab0
         zjg5qUC/LFITi2p5goDND0Va35XmlMNqdNKvJ5TIKmwRxBEjDDmMy0jAOnxHrPvXuWIW
         1raXG3ScztuTegtrDj6Lz4XYPPsZcN8L+nbyjCFyEJ0w1doT3rouAReqTJoYBMdWE/af
         K9UhNsnLwG3M3sYyUwqjmJ2f804XwdAwdGlBYwoD3qrr+7yOlwcfn+Tzbt5VY6pEFX0Z
         dtxw==
X-Gm-Message-State: APjAAAU18b94owiBfmO8b56MD8CFe2uSGK+JRnK3XqofTRCzoZP2GYRl
        801Ko5NqovSDI7kFqCD9O0fXBO6iqiJYKOixK2Q=
X-Google-Smtp-Source: APXvYqzN4IWqepyuZPklF7L8ozZI4LbiAv4GV0RtDKUIgzmwtmu2HCHaKAEwQX+jqfXdOOVP/nkjYjijiJ/ZgcuA+so=
X-Received: by 2002:a05:620a:1530:: with SMTP id n16mr12139406qkk.394.1581599137246;
 Thu, 13 Feb 2020 05:05:37 -0800 (PST)
MIME-Version: 1.0
References: <20200212172729.260752-1-jlayton@kernel.org>
In-Reply-To: <20200212172729.260752-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 13 Feb 2020 21:05:25 +0800
Message-ID: <CAAM7YAmz9U4TmBMNhFV+4xiDRNM5GVwhe94wZmedwp7g4RgFoQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] ceph: add support for asynchronous directory operations
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, idridryomov@gmail.com,
        Sage Weil <sage@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Feb 13, 2020 at 1:29 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> I've dropped the async unlink patch from testing branch and am
> resubmitting it here along with the rest of the create patches.
>
> Zheng had pointed out that DIR_* caps should be cleared when the session
> is reconnected. The underlying submission code needed changes to
> handle that so it needed a bit of rework (along with the create code).
>
> Since v3:
> - rework async request submission to never queue the request when the
>   session isn't open
> - clean out DIR_* caps, layouts and delegated inodes when session goes down
> - better ordering for dependent requests
> - new mount options (wsync/nowsync) instead of module option
> - more comprehensive error handling
>
> Jeff Layton (9):
>   ceph: add flag to designate that a request is asynchronous
>   ceph: perform asynchronous unlink if we have sufficient caps
>   ceph: make ceph_fill_inode non-static
>   ceph: make __take_cap_refs non-static
>   ceph: decode interval_sets for delegated inos
>   ceph: add infrastructure for waiting for async create to complete
>   ceph: add new MDS req field to hold delegated inode number
>   ceph: cache layout in parent dir on first sync create
>   ceph: attempt to do async create when possible
>
>  fs/ceph/caps.c               |  73 +++++++---
>  fs/ceph/dir.c                | 101 +++++++++++++-
>  fs/ceph/file.c               | 253 +++++++++++++++++++++++++++++++++--
>  fs/ceph/inode.c              |  58 ++++----
>  fs/ceph/mds_client.c         | 156 +++++++++++++++++++--
>  fs/ceph/mds_client.h         |  17 ++-
>  fs/ceph/super.c              |  20 +++
>  fs/ceph/super.h              |  21 ++-
>  include/linux/ceph/ceph_fs.h |  17 ++-
>  9 files changed, 637 insertions(+), 79 deletions(-)
>

Please implement something like
https://github.com/ceph/ceph/pull/32576/commits/e9aa5ec062fab8324e13020ff2f583537e326a0b.
MDS may revoke Fx when replaying unsafe/async requests. Make mds not
do this is quite complex.

> --
> 2.24.1
>
