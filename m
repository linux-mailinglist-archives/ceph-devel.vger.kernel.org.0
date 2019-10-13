Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 444A2D55C1
	for <lists+ceph-devel@lfdr.de>; Sun, 13 Oct 2019 13:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbfJMLTq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 13 Oct 2019 07:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728620AbfJMLTq (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 13 Oct 2019 07:19:46 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20B6F20659;
        Sun, 13 Oct 2019 11:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570965585;
        bh=AGE2pLJEcqWm7oQJ7BRPIZi5R/hfODBLYdWNecuV/K0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=xYrrYv0Csg+NBOViYiX0DH/e3JGCfGez2c3fgvGZrzokqgNOk1DN4OIyJj+ccM+jE
         OYSKdMEZ+DyrjAB1qhSbHAsWAkawAAdMZbhxkyQYVRyuJKcy8lZvmZsw5LySOwDZsO
         VWZTYCL+Cp3U6qA92lZEXz8no/AipjPp8ce6H2fg=
Message-ID: <78d8aae33c9d4ccccf32698285c91664965afbcd.camel@kernel.org>
Subject: Re: Hung CephFS client
From:   Jeff Layton <jlayton@kernel.org>
To:     Robert LeBlanc <robert@leblancnet.us>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Date:   Sun, 13 Oct 2019 07:19:43 -0400
In-Reply-To: <CAANLjFpvyTiSanWVOdHvaLjP_oqyPikKeDJ9oMqUq=1SS7GX-w@mail.gmail.com>
References: <CAANLjFpQuOjeGkD_+0LNTeLystCKJ6WqA7A3X4vNgu8n+L8KWw@mail.gmail.com>
         <e9890c9feabe863dacf702327fd219f3a76fac57.camel@kernel.org>
         <CAANLjFpvyTiSanWVOdHvaLjP_oqyPikKeDJ9oMqUq=1SS7GX-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2019-10-12 at 11:20 -0700, Robert LeBlanc wrote:
> On Fri, Oct 11, 2019 at 5:47 PM Jeff Layton <jlayton@kernel.org> wrote:
> > What kernel version is this? Do you happen to have a more readable stack
> > trace? Did this come from a hung task warning in the kernel?
> 
> $ uname -a
> Linux sun-gpu225 4.4.0-142-generic #168~14.04.1-Ubuntu SMP Sat Jan 19
> 11:26:28 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
> 

That's pretty old. I'm not sure how aggressively Canonical backports
ceph patches.

> This was the best stack trace we could get. /proc was not helpful:
> root@sun-gpu225:/proc/77292# cat stack
> 
> 
> 
> [<ffffffffffffffff>] 0xffffffffffffffff
> 

A stack trace like the above generally means that the task is running in
userland. The earlier stack trace you sent might just indicate that it
was in the process of spinning on a lock when you grabbed the trace, but
isn't actually stuck in the kernel.

> We did not get messages of hung tasks from the kernel. This container
> was running for 9 days when the jobs should have completed in a matter
> of hours. They were not able to stop the container, but it still was
> using CPU. So it smells like uninterruptable sleep, but still using
> CPU which based on the trace looks like it's stuck in spinlock.
> 

That could be anything then, including userland bugs. What state was the
process in (maybe grab /proc/<pid>/status if this happens again?).

> Do you want me to get something more specific? Just tell me how.
> 

If you really think tasks are getting hung in the kernel, then you can
crash the box and get a vmcore if you have kdump set up. With that we
can analyze it and determine what it's doing.

If you suspect ceph is involved then you might want to turn up dynamic
debugging in the kernel and see what it's doing.
-- 
Jeff Layton <jlayton@kernel.org>

