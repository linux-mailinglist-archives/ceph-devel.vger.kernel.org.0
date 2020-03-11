Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C39751816C8
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Mar 2020 12:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgCKLZ1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Mar 2020 07:25:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:46102 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgCKLZ1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 07:25:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1D857ABF4;
        Wed, 11 Mar 2020 11:25:25 +0000 (UTC)
Received: from localhost (webern.olymp [local])
        by webern.olymp (OpenSMTPD) with ESMTPA id c9be3233;
        Wed, 11 Mar 2020 11:25:24 +0000 (WET)
Date:   Wed, 11 Mar 2020 11:25:24 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Marc Roos <M.Roos@f1-outsourcing.eu>,
        ceph-users <ceph-users@ceph.io>, ceph-devel@vger.kernel.org
Subject: Re: [ceph-users] cephfs snap mkdir strange timestamp
Message-ID: <20200311112524.GA72386@suse.com>
References: <"H000007100163fdf.1583792359.sx.f1-outsourcing.eu*"@MHS>
 <"H000007100164304.1583836879.sx.f1-outsourcing.eu*"@MHS>
 <20200310134613.GA74810@suse.com>
 <7f684a1a23c007858d996346532971bd0de9f138.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f684a1a23c007858d996346532971bd0de9f138.camel@kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 10, 2020 at 01:39:29PM -0400, Jeff Layton wrote:
...
> What about the atime, and the ci->i_btime ?

FYI, I've also created PR#33879 to also get the atime in the fuse client.

Cheers,
--
Luis
