Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D277584F
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 21:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfGYTr3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 15:47:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfGYTr3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 15:47:29 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FD64218EA;
        Thu, 25 Jul 2019 19:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564084048;
        bh=lhBZZtvTcMx28KF5OnTU58tGiuLN9yYbGfbIpfQ+76U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rgrD7l7M907jjbIC/l5VE9aKHi09WPiCfGnLhxWzl6PywjPdmCaGNOnxzYfJAkpsi
         xFRlu1jsDkn43AVyxshHt61vd22ip1zepwBKxXFHQEP2cBHYvQbpImUzQhdhrm6ee0
         rWemFOD5y3yGIKZ/WkNcZrnzVXemTsnTn5OnA+8Q=
Message-ID: <4b661f9b9be78c15eb378592f229c23c569e375a.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: don't list vxattrs in listxattr()
From:   Jeff Layton <jlayton@kernel.org>
To:     Gregory Farnum <gfarnum@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Cc:     David Disseldorp <ddiss@suse.de>,
        Luis Henriques <lhenriques@suse.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Thu, 25 Jul 2019 15:47:26 -0400
In-Reply-To: <CAJ4mKGb8CVOd55VTL6fpxGCJaHA6Eg2OZxUWQkXxaUOdsCNEMg@mail.gmail.com>
References: <20190724172026.23999-1-jlayton@kernel.org>
         <87ftmu4fq3.fsf@suse.com> <20190725115458.21e304c6@suse.com>
         <fd396da29b62b83559d7489757a3871b7453e7fa.camel@kernel.org>
         <20190725135854.66c3be3d@suse.de>
         <CA+2bHPbc86Kc9CSHj1PzZuEnY_8HLi1enAUjxTcNLuYREKvKmg@mail.gmail.com>
         <CAJ4mKGb8CVOd55VTL6fpxGCJaHA6Eg2OZxUWQkXxaUOdsCNEMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-07-25 at 12:10 -0700, Gregory Farnum wrote:
> On Thu, Jul 25, 2019 at 12:04 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
> > On Thu, Jul 25, 2019 at 4:59 AM David Disseldorp <ddiss@suse.de> wrote:
> > > On Thu, 25 Jul 2019 07:17:11 -0400, Jeff Layton wrote:
> > > 
> > > > Yeah, I rolled a half-assed xfstests patch that did this, and HCH gave
> > > > it a NAK. He's probably right though, and fixing it in ceph.ko is a
> > > > better approach I think.
> > > 
> > > It sounds as though Christoph's objection is to any use of a "ceph"
> > > xattr namespace for exposing CephFS specific information. I'm not sure
> > > what the alternatives would be, but I find the vxattrs much nicer for
> > > consumption compared to ioctls, etc.
> > 
> > Agreed. I don't understand the objection [1] at all.
> > 
> > If the issue is that utilities copying a file may also copy xattrs, I
> > don't understand why there would be an expectation that all xattrs are
> > copyable or should be copied.
> 
> I'm sure it is about this, and that's the expectation because, uh,
> outside of weird things like Ceph then all matters are copyable and
> should be copied. That's how the interface is defined and built.
> 
> I'm actually a bit puzzled to see this patch go by because I didn't
> think we listed the ceph.* matters on a listxattr command! If we want
> discoverability (to see what options are available on a running
> system) we can return them in response to a getxattr on the "ceph"
> xattr or something.

Yeah, that would be better, I think. For the record, ceph-fuse seems to
also report these via listxattr. Testing with a build as of this
morning:

$ strace -e listxattr -f -s 256 getfattr -m '.' scratch
listxattr("scratch", NULL, 0)           = 133
listxattr("scratch", "ceph.dir.entries\0ceph.dir.files\0ceph.dir.subdirs\0ceph.dir.rentries\0ceph.dir.rfiles\0ceph.dir.rsubdirs\0ceph.dir.rbytes\0ceph.dir.rctime\0", 256) = 133

It might be good to have it stop doing this as well.
--
Jeff Layton <jlayton@kernel.org>

