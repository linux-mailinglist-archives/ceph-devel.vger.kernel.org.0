Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1B51A78B8
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Apr 2020 12:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438494AbgDNKqj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Apr 2020 06:46:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438529AbgDNKnP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Apr 2020 06:43:15 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 248D520644;
        Tue, 14 Apr 2020 10:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586860995;
        bh=5IUAk3KsI/tk9Tw23WQsjipr5cuVynsx9WLVlBSWLdw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=x6hta4FF74MX+VE7BAZVD32QS9EWjL/rbBNRXDILqAAJAjSuaTWqgLNHIVAj7ASqy
         WfQ5Qbc9DIstx+6gRl6TwQAQ/gLupdBeNibnvYd+H3HaK9+IKrWFeQrZuUO2npRm8e
         AyuB2p3zgs+sEzoc2au6p/jc7TJOVkq91SiID3g4=
Message-ID: <dbbf8ac2491089a864bab08a83ca89ca2fd65d5f.camel@kernel.org>
Subject: Re: [PATCH 1/2] ceph: have ceph_mdsc_free_path ignore ERR_PTR values
From:   Jeff Layton <jlayton@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>
Date:   Tue, 14 Apr 2020 06:43:14 -0400
In-Reply-To: <20200413194153.GD14511@kadam>
References: <20200408142125.52908-1-jlayton@kernel.org>
         <20200408142125.52908-2-jlayton@kernel.org>
         <CAOi1vP99BbHFrrg+0HAbZrZV7DQ7EG7euTY6cbtdWajsdyN3jQ@mail.gmail.com>
         <ded1b71dcda70e3a249df21c294607dac6545694.camel@kernel.org>
         <CAOi1vP9mZTShECrVVohuj4p=Yr+rWvWnXNY03c85CuO4fGNSyQ@mail.gmail.com>
         <55c47d66b579fcf5749376c73d681d0273095f6d.camel@kernel.org>
         <20200413194153.GD14511@kadam>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-04-13 at 22:41 +0300, Dan Carpenter wrote:
> On Mon, Apr 13, 2020 at 09:23:22AM -0400, Jeff Layton wrote:
> > > > I don't see a problem with having a "free" routine ignore IS_ERR values
> > > > just like it does NULL values. How about I just trim off the other
> > > > deltas in this patch? Something like this?
> > > 
> > > I think it encourages fragile code.  Less so than functions that
> > > return pointer, NULL or IS_ERR pointer, but still.  You yourself
> > > almost fell into one of these traps while editing debugfs.c ;)
> > > 
> > 
> > We'll have to agree to disagree here. Having a free routine ignore
> > ERR_PTR values seems perfectly reasonable to me.
> 
> Freeing things which haven't been allocated is a constant source bugs.
> 
> err:
> 	kfree(foo->bar);
> 	kfree(foo);
> 
> Oops...  "foo" wasn't allocated so the first line will crash.  Every
> other day someone commits code like that.
> 

It's not clear to me whether you're advocating for Ilya's approach or
mine (neither? both?). Which approach do you think is best?

FWIW, my rationale for doing it this way is that the "allocator" for
ceph_mdsc_free_path is ceph_mdsc_build_path. That routine returns an
ERR_PTR value on failure, not a NULL pointer, so it makes sense to me
to have the free routine accept and ignore those values.

I don't quite follow the rationale that that encourages fragile code.
-- 
Jeff Layton <jlayton@kernel.org>

