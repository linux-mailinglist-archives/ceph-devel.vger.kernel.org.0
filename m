Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E66F31348D
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Feb 2021 15:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhBHOHf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Feb 2021 09:07:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:39086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231666AbhBHOFK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 8 Feb 2021 09:05:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5791C64E5A;
        Mon,  8 Feb 2021 14:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612793069;
        bh=VTh81dpYDhAY3nlO1mevQkEojGsCdaUfX+z96yAPRRs=;
        h=Subject:From:To:Cc:Date:From;
        b=r+lDInWDc22OGuzeMv1ytKZqMfzJbiFwbMiqmQp8a5ok/xINWAMGjdqD3/qFUSCvx
         kU5IzzHZFsaMHOtoop9YXM4A99GD8IGQEcXxlTU/hQYj6uHfbINeJYpCXLrEUEpNLL
         GrWOnC/FsLNHtv1acplSrCQsuVL82AKrEOSHzXnuSLKVJAED8gldJ0Cvx+In1zgVzd
         3rjFhpJCFZeqgV3NfaK/Tww1KwrsArBliGt9PkknIlgSsuRPpx2NhjupV0NqHiJ+FQ
         L86e8+Wl1L7riT8YDDCh5EeeX+XNlTonBIdxHKwLvw70IIuRxZzdSaJOX/cfGIr028
         FDWN7X8wYeZxw==
Message-ID: <5476d29f00bacf41ef9ac094096a1627fe9c9a25.camel@kernel.org>
Subject: netfs-lib changes merged into testing branch
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>
Date:   Mon, 08 Feb 2021 09:04:28 -0500
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

A little later than expected, but I've gone ahead and merged the
conversion to the netfs read helpers into the ceph-client/testing
branch. I did this by just merging David's fscache-next branch before
layering the current patches in testing on top.

This should make it the default kernel to be used on most teuthology
runs that involve a kclient. Let me know if you see cephfs I/O-related
issues pop up (but I'm not expecting many -- we've been testing this
privately for quite a while now).

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

