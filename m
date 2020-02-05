Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABCE615355F
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Feb 2020 17:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgBEQi5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Feb 2020 11:38:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbgBEQi4 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 5 Feb 2020 11:38:56 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C39B121741;
        Wed,  5 Feb 2020 16:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580920736;
        bh=G3zuMVACE75yo0b4jyUNG8LzxLcTEeYyafADfffN9vk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dj6eVveD1T+4qff1ffx4PcYvYPlwOXz3pF9w3PeSClDCQqKLasZOWTYIF9rxihrnJ
         GQ9TBROOc0G4m9uA/Y1RJUNHPpIl9Pt3SSl3E8QkjN5VuJxBge/3If2DAnMVb+Oifg
         dNZmJYPwPqosM4I02zOecCYA9iqNfxGrsVx+Dh0Y=
Message-ID: <e9677dc33eecf80ee988e946cc84a4d9a9803d15.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: serialize the direct writes when couldn't
 submit in a single req
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 05 Feb 2020 11:38:54 -0500
In-Reply-To: <06b35b716c6f158360f2a21f00c3c1c0232562cc.camel@kernel.org>
References: <20200204015445.4435-1-xiubli@redhat.com>
         <06b35b716c6f158360f2a21f00c3c1c0232562cc.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-02-05 at 11:24 -0500, Jeff Layton wrote:
> On Mon, 2020-02-03 at 20:54 -0500, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > If the direct io couldn't be submit in a single request, for multiple
> > writers, they may overlap each other.
> > 
> > For example, with the file layout:
> > ceph.file.layout="stripe_unit=4194304 stripe_count=1 object_size=4194304
> > 
> > fd = open(, O_DIRECT | O_WRONLY, );
> > 
> > Writer1:
> > posix_memalign(&buffer, 4194304, SIZE);
> > memset(buffer, 'T', SIZE);
> > write(fd, buffer, SIZE);
> > 
> > Writer2:
> > posix_memalign(&buffer, 4194304, SIZE);
> > memset(buffer, 'X', SIZE);
> > write(fd, buffer, SIZE);
> > 
> > From the test result, the data in the file possiblly will be:
> > TTT...TTT <---> object1
> > XXX...XXX <---> object2
> > 
> > The expected result should be all "XX.." or "TT.." in both object1
> > and object2.
> > 
> 
> I really don't see this as broken. If you're using O_DIRECT, I don't
> believe there is any expectation that the write operations (or even read
> operations) will be atomic wrt to one another.
> 
> Basically, when you do this, you're saying "I know what I'm doing", and
> need to provide synchronization yourself between competing applications
> and clients (typically via file locking).
> 

In fact, here's a discussion about this from a couple of years ago. This
one mostly applies to local filesystems, but the same concepts apply to
CephFS as well:


https://www.spinics.net/lists/linux-fsdevel/msg118115.html

-- 
Jeff Layton <jlayton@kernel.org>

