Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137D550F1BE
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Apr 2022 09:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343751AbiDZHKH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Apr 2022 03:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343813AbiDZHKD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Apr 2022 03:10:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7369C37AA9;
        Tue, 26 Apr 2022 00:06:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27715B81C68;
        Tue, 26 Apr 2022 07:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69C5C385A0;
        Tue, 26 Apr 2022 07:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650956813;
        bh=oSzk4INeEyNYqL69BKf5W0+B/RgiGVMCN//FIn7UBhk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cz8eCdcepHEQtuNEyaV0ocMBId8zoIVaBdV+6ZTytKrOMOcRPajGzorT4LLLVFEM8
         DX33qSHMq36/OPFgiZJRV9kCUTUeuI59Ap4K3TNtDfhMr6xc49uRykF9zifqSnlcsU
         THTQ0BTSefSqgb8mCTn2q/7x5kq81tkMRGqq/KraxvdChMBLMKdcTzq8p1IE5+RWfK
         MhpuTsl8HXJuwBqxKa5GAjAaaYr68lHJI8yQObJ3Yal32WoBMHUp1BggTOPLInl6cY
         QAZKTWP3jmnccyobut0njXzFN4Bjn/02qY98EIu+5q3uguZPZLCop8DD48MwCLGeCr
         DpyfvizwTC5Lw==
Date:   Tue, 26 Apr 2022 09:06:48 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Yang Xu <xuyang2018.jy@fujitsu.com>
Cc:     linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
        viro@zeniv.linux.org.uk, david@fromorbit.com, djwong@kernel.org,
        willy@infradead.org, jlayton@kernel.org
Subject: Re: [PATCH v7 1/4] fs: move sgid stripping operation from
 inode_init_owner into mode_strip_sgid
Message-ID: <20220426070648.3k6dahljcjhpggur@wittgenstein>
References: <1650946792-9545-1-git-send-email-xuyang2018.jy@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1650946792-9545-1-git-send-email-xuyang2018.jy@fujitsu.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Apr 26, 2022 at 12:19:49PM +0800, Yang Xu wrote:
> This has no functional change. Just create and export mode_strip_sgid
> api for the subsequent patch. This function is used to strip S_ISGID mode
> when init a new inode.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
> ---

Since this is a very sensitive patch series I think we need to be
annoyingly pedantic about the commit messages. This is really only
necessary because of the nature of these changes so you'll forgive me
for being really annoying about this. Here's what I'd change the commit
message to:

fs: add mode_strip_sgid() helper

Add a dedicated helper to handle the setgid bit when creating a new file
in a setgid directory. This is a preparatory patch for moving setgid
stripping into the vfs. The patch contains no functional changes.

Currently the setgid stripping logic is open-coded directly in
inode_init_owner() and the individual filesystems are responsible for
handling setgid inheritance. Since this has proven to be brittle as
evidenced by old issues we uncovered over the last months (see [1] to
[3] below) we will try to move this logic into the vfs.

Link: e014f37db1a2 ("xfs: use setattr_copy to set vfs inode attributes" [1]
Link: 01ea173e103e ("xfs: fix up non-directory creation in SGID directories") [2]
Link: fd84bfdddd16 ("ceph: fix up non-directory creation in SGID directories") [3]
