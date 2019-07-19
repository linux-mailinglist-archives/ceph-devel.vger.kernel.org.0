Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C74286ECB2
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Jul 2019 01:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732639AbfGSXXP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Jul 2019 19:23:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41292 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728909AbfGSXXP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 19 Jul 2019 19:23:15 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hocDU-0006cq-4i; Fri, 19 Jul 2019 23:23:08 +0000
Date:   Sat, 20 Jul 2019 00:23:08 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Luis Henriques <lhenriques@suse.com>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ceph: fix buffer free while holding i_ceph_lock in
 __ceph_setxattr()
Message-ID: <20190719232307.GA17978@ZenIV.linux.org.uk>
References: <20190719143222.16058-1-lhenriques@suse.com>
 <20190719143222.16058-3-lhenriques@suse.com>
 <1dee14212043f12ef5b26e4aee0c3155e118abf3.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dee14212043f12ef5b26e4aee0c3155e118abf3.camel@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 19, 2019 at 07:07:49PM -0400, Jeff Layton wrote:

> Al pointed out on IRC that vfree should be callable under spinlock.

Al had been near-terminally low on caffeine at the time, posted
a retraction a few minutes later and went to grab some coffee...

> It
> only sleeps if !in_interrupt(), and I think that should return true if
> we're holding a spinlock.

It can be used from RCU callbacks and all such; it *can't* be used from
under spinlock - on non-preempt builds there's no way to recognize that.
