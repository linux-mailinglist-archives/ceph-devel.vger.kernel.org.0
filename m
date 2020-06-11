Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34E41F6C1E
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jun 2020 18:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgFKQZA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Jun 2020 12:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgFKQZA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 11 Jun 2020 12:25:00 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBC15206C3;
        Thu, 11 Jun 2020 16:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591892700;
        bh=U05D87HvYaCcRem1ndxqAySNE/qmvR0ZW2mb91Ur6dE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G3pItbaAJOQGFzSaBhEhT5hGc6KVK4ei5v5khllgi9+QH3Gtbn9yIuWV+QQS99GZB
         3tp/PhTT9XArYeJ2HDGlPVHd3aCZvSEmKGwrn6vPXUWGpEqTQLq1ZqcxXzZaz29g6W
         hrG0rGZfxkvpwDHU+/I2qSKklGN0TPSU+TKPZpoo=
Message-ID: <7ae2e9ec09cddaf1cb6420bfe6758becc7fb434b.camel@kernel.org>
Subject: Re: Questions of QoS on ceph
From:   Jeff Layton <jlayton@kernel.org>
To:     norman <norman.kern@gmx.com>, ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, ceph-users <ceph-users@ceph.io>
Date:   Thu, 11 Jun 2020 12:24:58 -0400
In-Reply-To: <b8eca4d9-e368-0f35-f3dc-6049d9a213fd@gmx.com>
References: <b8eca4d9-e368-0f35-f3dc-6049d9a213fd@gmx.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-06-10 at 16:38 +0800, norman wrote:
> Hi guys,
> 
> I want to setup a  ceph cluster for teams, using fs and s3 interface. I
> met a problem about the QoS: How can I limit the
> 
> bw or qps of a client to avoid the someone blocking others by running
> lots of threads?
> 

(this is probably a better question for ceph-users mailing list.
cc'ed...)

It's not clear to me which one concerns you most:

1/ parceling out a single client's resources between different tasks
(e.g. multiple programs interacting on a kcephfs mount).

2/ parceling out resources of the entire cluster between different
clients

...both turn out to be pretty thorny problems, and ceph doesn't really
have much in the way of mechanisms for addressing either.

The Ceph MDS can do things like recall caps to manage resources but I
don't believe it does that in response to (e.g.) excess activity vs. a
single OSD. It's more focused on its own memory consumption.

-- 
Jeff Layton <jlayton@kernel.org>

