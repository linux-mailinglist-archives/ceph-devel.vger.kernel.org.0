Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75C7374DA0
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 13:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404406AbfGYL6z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 07:58:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:34062 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404362AbfGYL6z (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:58:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9C4D5AFAE;
        Thu, 25 Jul 2019 11:58:54 +0000 (UTC)
Date:   Thu, 25 Jul 2019 13:58:54 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     "Jeff Layton" <jlayton@kernel.org>
Cc:     "Luis Henriques" <lhenriques@suse.com>,
        <ceph-devel@vger.kernel.org>
Subject: Re: [RFC PATCH] ceph: don't list vxattrs in listxattr()
Message-ID: <20190725135854.66c3be3d@suse.de>
In-Reply-To: <fd396da29b62b83559d7489757a3871b7453e7fa.camel@kernel.org>
References: <20190724172026.23999-1-jlayton@kernel.org>
        <20190724172026.23999-1-jlayton@kernel.org>
        <87ftmu4fq3.fsf@suse.com>
        <20190725115458.21e304c6@suse.com>
        <fd396da29b62b83559d7489757a3871b7453e7fa.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 25 Jul 2019 07:17:11 -0400, Jeff Layton wrote:

> Yeah, I rolled a half-assed xfstests patch that did this, and HCH gave
> it a NAK. He's probably right though, and fixing it in ceph.ko is a
> better approach I think.

It sounds as though Christoph's objection is to any use of a "ceph"
xattr namespace for exposing CephFS specific information. I'm not sure
what the alternatives would be, but I find the vxattrs much nicer for
consumption compared to ioctls, etc.

> > Samba currently only makes use of the ceph.snap.btime vxattr. It doesn't
> > depend on it appearing in the listxattr(), so removal would be fine. Not
> > sure about other applications though.
> > 
> > Cheers, David  
> 
> Ok, thanks guys. I'll go ahead and push this into the ceph/testing
> branch and see if teuthology complains.

Sounds good. Feel free to add my RB tag.

Cheers, David
