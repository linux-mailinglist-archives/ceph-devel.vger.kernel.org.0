Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB5D1CF8B2
	for <lists+ceph-devel@lfdr.de>; Tue, 12 May 2020 17:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbgELPN1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 12 May 2020 11:13:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:51700 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbgELPN1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 12 May 2020 11:13:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C5C64AB64;
        Tue, 12 May 2020 15:13:28 +0000 (UTC)
Received: from localhost (webern.olymp [local])
        by webern.olymp (OpenSMTPD) with ESMTPA id 16753714;
        Tue, 12 May 2020 16:13:25 +0100 (WEST)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org
Subject: Help understanding xfstest generic/467 failure
Date:   Tue, 12 May 2020 16:13:24 +0100
Message-ID: <878shx190r.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff,

I've been looking at xfstest generic/467 failure in cephfs, and I simply
can not decide if it's a genuine bug on ceph kernel code.  Since you've
recently been touching the ceph_unlink code maybe you could help me
understanding what's going on.

generic/467 runs a couple of tests using src/open_by_handle, but the one
failing can be summarized with the following:

- get a handle to /cephfs/myfile using name_to_handle_at(2)
- open(2) file /cephfs/myfile
- unlink(2) /cephfs/myfile
- drop caches
- open_by_handle_at(2) => returns -ESTALE

This test succeeds opening the handle with other (local) filesystems
(maybe I should run it with other networked filesystem such as NFS).

The -ESTALE is easy to trace to __fh_to_dentry, where inode->i_nlink is
checked against 0.  My question is: should we really be testing the
i_nlink here?  We dropped the name, but the file may still be there (as in
this case).

I guess I'm missing something, but hopefully you'll be able to shed some
light on this.  Thanks in advance for any help you may provide!

Cheers,
-- 
Luis
