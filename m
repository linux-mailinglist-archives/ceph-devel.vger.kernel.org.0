Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C318715BF0F
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 14:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbgBMNUH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 08:20:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbgBMNUH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Feb 2020 08:20:07 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B0DB2168B;
        Thu, 13 Feb 2020 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581600006;
        bh=zWEMq2z634Eprv8TnOaLvIi52+QTEWZwVYIgAhqGVuw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AXn5TqpUQzKCG41b0jqLC0KVNpj4ZFcqZ4LvGHpkk6mpxvN4HdbwJZB8hGL9R5GEI
         h1kSjZ+NyaZ8ePB09ZvGoI+9F+GR7nZ+H+Mnawj0T7pHFtmhG9NuHcMZTacFIgGBc3
         ioh/ByEk4cru5VKUGnrkBxIT9AWOT2nbgt5EkAkA=
Message-ID: <079aab73e6d189de419dce98057c687b734134fc.camel@kernel.org>
Subject: Re: [PATCH v4 0/9] ceph: add support for asynchronous directory
 operations
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, idridryomov@gmail.com,
        Sage Weil <sage@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 13 Feb 2020 08:20:04 -0500
In-Reply-To: <CAAM7YAmz9U4TmBMNhFV+4xiDRNM5GVwhe94wZmedwp7g4RgFoQ@mail.gmail.com>
References: <20200212172729.260752-1-jlayton@kernel.org>
         <CAAM7YAmz9U4TmBMNhFV+4xiDRNM5GVwhe94wZmedwp7g4RgFoQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-02-13 at 21:05 +0800, Yan, Zheng wrote:
> On Thu, Feb 13, 2020 at 1:29 AM Jeff Layton <jlayton@kernel.org> wrote:
> > I've dropped the async unlink patch from testing branch and am
> > resubmitting it here along with the rest of the create patches.
> > 
> > Zheng had pointed out that DIR_* caps should be cleared when the session
> > is reconnected. The underlying submission code needed changes to
> > handle that so it needed a bit of rework (along with the create code).
> > 
> > Since v3:
> > - rework async request submission to never queue the request when the
> >   session isn't open
> > - clean out DIR_* caps, layouts and delegated inodes when session goes down
> > - better ordering for dependent requests
> > - new mount options (wsync/nowsync) instead of module option
> > - more comprehensive error handling
> > 
> > Jeff Layton (9):
> >   ceph: add flag to designate that a request is asynchronous
> >   ceph: perform asynchronous unlink if we have sufficient caps
> >   ceph: make ceph_fill_inode non-static
> >   ceph: make __take_cap_refs non-static
> >   ceph: decode interval_sets for delegated inos
> >   ceph: add infrastructure for waiting for async create to complete
> >   ceph: add new MDS req field to hold delegated inode number
> >   ceph: cache layout in parent dir on first sync create
> >   ceph: attempt to do async create when possible
> > 
> >  fs/ceph/caps.c               |  73 +++++++---
> >  fs/ceph/dir.c                | 101 +++++++++++++-
> >  fs/ceph/file.c               | 253 +++++++++++++++++++++++++++++++++--
> >  fs/ceph/inode.c              |  58 ++++----
> >  fs/ceph/mds_client.c         | 156 +++++++++++++++++++--
> >  fs/ceph/mds_client.h         |  17 ++-
> >  fs/ceph/super.c              |  20 +++
> >  fs/ceph/super.h              |  21 ++-
> >  include/linux/ceph/ceph_fs.h |  17 ++-
> >  9 files changed, 637 insertions(+), 79 deletions(-)
> > 
> 
> Please implement something like
> https://github.com/ceph/ceph/pull/32576/commits/e9aa5ec062fab8324e13020ff2f583537e326a0b.
> MDS may revoke Fx when replaying unsafe/async requests. Make mds not
> do this is quite complex.
> 

I added this in reconnect_caps_cb in the latest set:

        /* These are lost when the session goes away */                         
        if (S_ISDIR(inode->i_mode)) {                                           
                if (cap->issued & CEPH_CAP_DIR_CREATE) {                        
                        ceph_put_string(rcu_dereference_raw(ci->i_cached_layout.pool_ns));
                        memset(&ci->i_cached_layout, 0, sizeof(ci->i_cached_layout));
                }                                                               
                cap->issued &= ~(CEPH_CAP_DIR_CREATE|CEPH_CAP_DIR_UNLINK);      
        }                                                                       

Basically, wipe out the layout and Duc caps when we reconnect the
session. Outstanding references to the caps will be put when the call
completes. Is that not sufficient?
-- 
Jeff Layton <jlayton@kernel.org>

