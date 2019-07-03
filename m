Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B6C5DF4F
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 10:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfGCIJn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 04:09:43 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38675 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfGCIJn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Jul 2019 04:09:43 -0400
Received: by mail-io1-f66.google.com with SMTP id j6so2681312ioa.5
        for <ceph-devel@vger.kernel.org>; Wed, 03 Jul 2019 01:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0pPl85eXtBTjLjXsh9wjwr+XE4H3UNzPLQzB9yqvlcI=;
        b=Dv4vDRYMqQtaMMgEmSbdtQtz++0y2LY8Fg4akFr68xJeViOlW6cte0IiZa5NhXkuyS
         w/sR8brDifS0ARpmrOKBeP0YaS9khXeTs6J2Ufd32tNaAXC7o1b7Lo57muwQjS/aAcJp
         1m5K54Hn+vmilAU6VznRu1Cm+oRe9hmyFcf8/m9xG1Eohg2YRIH4dmsZKn5qd9uVaF1C
         GN2SxY/Svvcy757sun+LgQmxPTtqUwpbooZlqPaZw4gIRsfKiItTrJKXXjeM2G5Qlito
         RVV438l710ToTw3ul6OaNT73L5cN9vZo86ze5Yq1xco/hafDizNzMgQOLwXKiOYuwVq5
         +cvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0pPl85eXtBTjLjXsh9wjwr+XE4H3UNzPLQzB9yqvlcI=;
        b=I5WOfC41ZlJHFYLXEVvXmVLhEYZq0mpC3TucjPwfgjtX8oij1PJeZjR/C3+8iSXkuk
         Sji75nO2/iPBBDIEgei4mTp1d+MIwwFJmn2IXl9TVglMV1cABRAOTteRIqWSb86/5Cyi
         PmPNYvpEVHH9EQQNKsEn0bfCsPdwdgq+cIO/BXlp+7VGtKznQccACtjJ63L2pUuKPfnX
         6SWMwL0ApqfcBz2TqPYvHsPXiDZ4XJfhk6A4oxZDg8bgUqmKGyurrD7lKOy1/nqMaUn4
         RHCxbHqYfcIwSnenfmzl/k5ol/nciRR+BQmq+3cjMUkv1kgsFSf4zXTyp4T8L+B8RBaU
         xIBQ==
X-Gm-Message-State: APjAAAUMq9B30GF7JrL5ipMsyPiBaW0ckNlklzuV4Ls+IvGQN8mmcHj6
        mRZgt3ZmrbofjqV7wg/TGgUSDEcenPTx+r0x0JRXUQ3p
X-Google-Smtp-Source: APXvYqx/qewyYkZMV4OiUhB88YltOzuUr0QQrDOZYLwCFa7OCCMmm8ypYVjZKP1KFW4doRBKUynakM3WD9Hjgz66Sks=
X-Received: by 2002:a05:6638:149:: with SMTP id y9mr41177359jao.76.1562141382469;
 Wed, 03 Jul 2019 01:09:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190625144111.11270-1-idryomov@gmail.com> <db51e9b9-1eed-2257-6201-2a43c3cdaf98@petasan.org>
In-Reply-To: <db51e9b9-1eed-2257-6201-2a43c3cdaf98@petasan.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 3 Jul 2019 10:12:22 +0200
Message-ID: <CAOi1vP-=ThJW1NgVFOXeWT4WbM2mKzHprYkZQjz3bgLT2NMdUw@mail.gmail.com>
Subject: Re: [PATCH 00/20] rbd: support for object-map and fast-diff
To:     Maged Mokhtar <mmokhtar@petasan.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Jun 30, 2019 at 3:55 PM Maged Mokhtar <mmokhtar@petasan.org> wrote:
>
>
>
> Hi Ilya,
>
> Nice work. Some comments/questions:
>
> 1) Generally having a state machine makes things easier to track as the
> code is less dispersed than before.
>
> 2) The running_list is used to keep track of inflight requests in case
> of exclusive lock to support rbd_quiesce_lock() when releasing the lock.
> It would be great to generalize this list to keep track of all inflight
> requests even in the case when lock is not required, it could be used to
> support a generic flush (similar to librbd work queue flush/drain).
> Having a generic inflight requests list will also make it easier to
> support other functions such as task aborts, request timeouts, flushing
> on pre-snapshots.

Hi Maged,

We could extend it in the future, but right now it is there just for
exclusive lock.  Likely, we would need a different list for tracking
all in-flight requests because if we start adding random requests
(e.g. those that don't require exclusive lock), deadlocks will occur.

>
> 3) For the acquiring_list, my concern is that while the lock is pending
> to be acquired, the requests are being accepted without a limit. In case
> there is a delay acquiring the lock, for example if the primary of the
> object header is down (which could block for ~ 25 sec) or worse if the
> pool is inactive, the count could well exceed the max queue depth + for
> write requests this can consume a lot of memory.

As you noted in a different email, it is limited by queue_depth.  No
different from regular I/O taking too long.

>
> 4) In rbd_img_exclusive_lock() at end, we queue an acquire lock task for
> every request. I understand this is a single threaded queue and if lock
> is acquired then all acquire tasks are cancelled, however i feel the
> queue could fill a lot. Any chance we can only schedule 1 acquire task ?

This is not new, it's done in existing code too.  queue_delayed_work()
bails if the work is already queued, so ->lock_dwork is never queued
more than once.

>
> 5) The state RBD_IMG_EXCLUSIVE_LOCK is used for both cases when image
> does not require exclusive lock + when lock is acquired. Cosmetically it
> may be better to separate them.

Not all requests require exclusive lock even if exclusive-lock feature
is enabled (e.g. reads when object-map feature is disabled).  We switch
from RBD_IMG_EXCLUSIVE_LOCK early (i.e. no waiting) in those cases and
the case of exclusive-lock feature being disabled just falls into that
basket.

>
> 6) Probably not an issue, but we are now creating a large number of
> mutexes, at least 2 for every request. Maybe we need to test in high
> iops/queue depths that there is no overhead for this.

Yes, that would be useful.  If you do that, please share your results!

We can get that down to one by reusing image requests with the help of
blk-mq.  We would still need to allocate them for accessing the parent
image, but for regular image requests it should be pretty easy to do.

Reusing object requests is going to be harder, but we could probably
preallocate one per image request, as that is by far the most common
case.

>
> 7) Is there any consideration to split the rbd module to multiple files
> ? Looking at how big librbd, fitting this in a single kernel file is
> challenging at best.

Dongsheng expressed this concern is well.  Personally, I don't mind
a large file as long as it is nicely structured.  Adding object-map and
fast-diff added just two forward declarations, one of which could be
avoided.

We are never going to fit the entire librbd into the kernel, no matter
how many files ;)  Breaking up into multiple files complicates blaming,
so I would rather keep it as is at this point.

Thanks,

                Ilya
