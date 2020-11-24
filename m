Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641AA2C26D4
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Nov 2020 14:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387872AbgKXNJP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 Nov 2020 08:09:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387608AbgKXNJP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 08:09:15 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C67B206D9;
        Tue, 24 Nov 2020 13:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606223354;
        bh=Xh1vCN+rL0BKrEhzFG6M2g6EJUZDfporWFoD+/Xd/6Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=wbg8QWxvwQNSIi6UB8ll+el+Qs/ISl1QWFTGV/qgEPZMaUaBknehJhpPmrw4Zj+K0
         V3xUMjYpI3MywrJx9SteXln8HOjIykdQRRNa4VhZMyuWK2/SJ/lw6E4Z3cQL2SyqKH
         PYNL5hJshvIZfJk68XITP+GkFtDfaCik2/OdpkmQ=
Message-ID: <890e73cac81113e5958a39789fa119b7437bb191.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: add ceph.caps vxattr
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 24 Nov 2020 08:09:12 -0500
In-Reply-To: <20201123173846.15045-1-lhenriques@suse.de>
References: <a12a732b67245cc02344405f7dd9fef4f3b47fbc.camel@kernel.org>
         <20201123173846.15045-1-lhenriques@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-11-23 at 17:38 +0000, Luis Henriques wrote:
> Add a new vxattr that allows userspace to list the caps for a specific
> directory or file.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
> Hi!
> 
> Here's a version that also shows the caps in hexadecimal format, as
> suggested by Jeff.  IMO the parenthesis and the '0x' prefix help the
> readability, but they may make it a bit harder for scripts to parsing the
> output.  I'm OK dropping those.
> 
> Cheers,

Looks good, merged into "testing".

I did make a slight change to the format -- instead of putting the hex
value in parenthesis, I separated the two fields with a /, which I think
should make things easier for scripts to parse.

You should be able to do something like this to get at the hex value for
testing:

    $ getfattr -n ceph.caps foo | cut -d / -f2

Let me know if you see issues with that and we can revisit the format.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

