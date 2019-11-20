Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B82103708
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Nov 2019 10:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbfKTJzj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Nov 2019 04:55:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:57940 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728018AbfKTJzj (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 04:55:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C27C06998A;
        Wed, 20 Nov 2019 09:55:37 +0000 (UTC)
Date:   Wed, 20 Nov 2019 09:55:36 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3] ceph: add new obj copy OSD Op
Message-ID: <20191120095536.GA13949@hermes.olymp>
References: <20191118120935.7013-1-lhenriques@suse.com>
 <3dc2df0ba5776fb0f7aaac3a099a938823ed0ebf.camel@kernel.org>
 <20191118140551.GA8951@hermes.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191118140551.GA8951@hermes.olymp>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Nov 18, 2019 at 02:05:51PM +0000, Luis Henriques wrote:
> On Mon, Nov 18, 2019 at 08:12:39AM -0500, Jeff Layton wrote:
> > On Mon, 2019-11-18 at 12:09 +0000, Luis Henriques wrote:
> > > Hi,
> > > 
> > > Before going ahead with a pull-request for ceph I would like to make sure
> > > we're all on the same page regarding the final fix for this problem.
> > > Thus, following this email, I'm sending 2 patches: one for ceph OSDs and
> > > the another for the kernel client.
> > > 
> > > * osd: add new 'copy-from-notrunc' operation
> > >   This patch shall be applied to ceph master after reverting commit
> > >   ba152435fd85 ("osd: add flag to prevent truncate_seq copy in copy-from
> > >   operation").  It adds a new operation that will be exactly the same as
> > >   the original 'copy-from' operation, but with the extra 2 parameters
> > >   (truncate_{seq,size})
> > > 
> > > * ceph: switch copy_file_range to 'copy-from-notrunc' operation
> > >   This will make the kernel client use the new OSD op in
> > >   copy_file_range.  One extra thing that could probably be added is
> > >   changing the mount options to NOCOPYFROM if the first call to
> > >   ceph_osdc_copy_from() fails.
> > > 
> > 
> > I probably wouldn't change the mount options to be different from what
> > was initially specified. How about just disable copy_file_range
> > internally for that superblock, and then pr_notice a message that says
> > that copy_file_range is being autodisabled. If they mount with '-o
> > nocopyfrom' that will make the warning go away.
> 
> Ok, that makes sense.  I'll include this in the next rev, which will
> probably be sent only after the pull-request for ceph goes in (assuming
> the OSD patch won't need any major rework).

FYI, yesterday I created the pull-request for this [1].  I thought I had
also sent an email to this thread, but I guess I didn't... so, here it
is :-) 

[1] https://github.com/ceph/ceph/pull/31728

Cheers,
--
Luís

> 
> > > Does this look good, or did I missed something from the previous
> > > discussion?
> > > 
> > > (One advantage of this approach: the OSD patch can be easily backported!)
> > > 
> > 
> > Yep, I think this looks like a _much_ simpler approach to the problem.
> 
> Agreed!
> 
> Cheers,
> --
> Luís
