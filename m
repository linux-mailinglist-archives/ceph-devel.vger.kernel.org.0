Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6FF74A72
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 11:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfGYJzB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 05:55:01 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:45426 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfGYJzB (ORCPT
        <rfc822;groupwise-ceph-devel@vger.kernel.org:0:0>);
        Thu, 25 Jul 2019 05:55:01 -0400
Received: from localhost (charybdis.suse.de [149.44.162.66])
        by smtp.nue.novell.com with ESMTP (TLS encrypted); Thu, 25 Jul 2019 11:54:59 +0200
Date:   Thu, 25 Jul 2019 11:54:58 +0200
From:   David Disseldorp <ddiss@suse.com>
To:     Luis Henriques <lhenriques@suse.com>
Cc:     Jeff Layton <jlayton@kernel.org>, <ceph-devel@vger.kernel.org>
Subject: Re: [RFC PATCH] ceph: don't list vxattrs in listxattr()
Message-ID: <20190725115458.21e304c6@suse.com>
In-Reply-To: <87ftmu4fq3.fsf@suse.com>
References: <20190724172026.23999-1-jlayton@kernel.org>
        <20190724172026.23999-1-jlayton@kernel.org>
        <87ftmu4fq3.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

On Thu, 25 Jul 2019 10:37:40 +0100, Luis Henriques wrote:

> Jeff Layton <jlayton@kernel.org> writes:
> 
> (CC'ing David)
> 
> > Most filesystems that provide virtual xattrs (e.g. CIFS) don't display
> > them via listxattr(). Ceph does, and that causes some of the tests in
> > xfstests to fail.
> >
> > Have cephfs stop listing vxattrs in listxattr. Userspace can always
> > query them directly when the name is known.  
> 
> I don't see a problem with this, unless we already have applications
> relying on this behaviour.  The first thing that came to my mind was
> samba, but I guess David can probably confirm whether this is true or
> not.
> 
> If we're unable to stop listing there xattrs, the other option for
> fixing the xfstests that _may_ be acceptable by the maintainers is to
> use an output filter (lots of examples in common/filter).

Samba currently only makes use of the ceph.snap.btime vxattr. It doesn't
depend on it appearing in the listxattr(), so removal would be fine. Not
sure about other applications though.

Cheers, David
