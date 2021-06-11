Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41C43A4463
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jun 2021 16:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhFKOy4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Jun 2021 10:54:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231288AbhFKOyz (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 10:54:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C607611CD;
        Fri, 11 Jun 2021 14:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623423176;
        bh=83d60YVi3iP/uzFACLgJCWjlXRinZ+7SrNEwD8DuC+o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NNuIE6uMpIo7IPVkXIksBTXkfzm90t/3o7A6Iqgx1An7TT29snGnuSkwoJudH3vrn
         TBnx+u217vKI9GqWqH9pWqDmIUXuBIVokQirYvI6XtKQzsaBp3rjanj75+jlkf+bEx
         1YzJCWe0YfKF8a2Z5+q4gDbv4TqWuGArDBLrtQN+JjkgxXm0e/VPCocv/5b8fuih9g
         opuzOcw4jf2H+OSJseETxkKoMnmhTexJfkXW3i2RRUYwLeyKCJvqusa9TUhVwxy+zv
         GruOcIz547vlah3duLH+dZz5i7glwbfzLt8lZvSNJWfglR14dBWXlCVl+EoxNArqJw
         JqqUl5NfQwMYQ==
Message-ID: <a24c3c070c9fc3529a51f00f9ccc3d0abdd0b821.camel@kernel.org>
Subject: Re: [PATCH 5/5] ceph: fold ceph_update_writeable_page into
 ceph_write_begin
From:   Jeff Layton <jlayton@kernel.org>
To:     Andrew W Elble <aweits@rit.edu>
Cc:     ceph-devel@vger.kernel.org, pfmeec@rit.edu,
        David Howells <dhowells@redhat.com>, linux-cachefs@redhat.com
Date:   Fri, 11 Jun 2021 10:52:55 -0400
In-Reply-To: <m2h7i45vzl.fsf@discipline.rit.edu>
References: <20200916173854.330265-1-jlayton@kernel.org>
         <20200916173854.330265-6-jlayton@kernel.org>
         <7817f98d3b2daafe113bf8290cc8c7adbb86fe99.camel@kernel.org>
         <m2h7i45vzl.fsf@discipline.rit.edu>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-06-11 at 10:14 -0400, Andrew W Elble wrote:
> We're seeing file corruption while running 5.10, bisected to 1cc1699070bd:
> 
> > > +static int ceph_write_begin(struct file *file, struct address_space *mapping,
> > > +			    loff_t pos, unsigned len, unsigned flags,
> > > +			    struct page **pagep, void **fsdata)
> 
> <snip>
> 
> > > +		/*
> > > +		 * In some cases we don't need to read at all:
> > > +		 * - full page write
> > > +		 * - write that lies completely beyond EOF
> > > +		 * - write that covers the the page from start to EOF or beyond it
> > > +		 */
> > > +		if ((pos_in_page == 0 && len == PAGE_SIZE) ||
> > > +		    (pos >= i_size_read(inode)) ||
> 
> Shouldn't this be '((pos & PAGE_MASK) >= i_size_read(inode)) ||' ?
> 
> Seems like fs/netfs/read_helper.c currently has the same issue?
> 

Yeah...I think you may be right. Have you tried a patch that does that
and does it fix the issue?

Also, do you happen to have a testcase that we could stick in xfstests
for this? If not, we can probably write one, but if you already have one
that'd be great.



> > > +		    (pos_in_page == 0 && (pos + len) >= i_size_read(inode))) {
> > > +			zero_user_segments(page, 0, pos_in_page,
> > > +					   pos_in_page + len, PAGE_SIZE);
> > > +			break;
> > > +		}
> 

-- 
Jeff Layton <jlayton@kernel.org>

