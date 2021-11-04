Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4528144530E
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Nov 2021 13:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbhKDMea (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Nov 2021 08:34:30 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:46120 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhKDMe3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Nov 2021 08:34:29 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5771B1FD35;
        Thu,  4 Nov 2021 12:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636029110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=v4TeahBM6EJHdtiWd3KJNOzMUx8hI1RH3Bu3D3RRisQ=;
        b=1ps7ttO1gXCu4RNUDjq7SuhCUSSe2yR78N8s4SxRdH06cZR2+xRctyOUt32c9wFAPS6Esh
        A2wGIBcPWFPOxVC5In+ph9sX3pX80C9o88N53FqQuDU83NHA4Z9Mw9ZzeXoOZ4kp0h1rpu
        a74Vd56kKZXpPDwfY3xX1P+0e8NKe8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636029110;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=v4TeahBM6EJHdtiWd3KJNOzMUx8hI1RH3Bu3D3RRisQ=;
        b=sR8I54LdVt33uWtws1AWmoh81kL41By1QPSewIgGQ9zUCHDSgOmhFyLM38DBN3xT4UElYM
        C80OzEu3i9O+WqCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CD61B13BD4;
        Thu,  4 Nov 2021 12:31:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vRiJL7XSg2HLDQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 04 Nov 2021 12:31:49 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 436958ce;
        Thu, 4 Nov 2021 12:31:49 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH v2 0/2] ceph: metrics for remote object copies
Date:   Thu,  4 Nov 2021 12:31:45 +0000
Message-Id: <20211104123147.1632-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi!

Here's v2 of this patchset.  The differences from v1:

  * Instead of changing ceph_osdc_copy_from() in libceph.ko to return an
    osd request, move that function into the cephfs code instead.

Other than that, the 2nd patch is quite similar to the one from v1: it
effectively hooks the 'copyfrom' metrics infrastructure.

Luís Henriques (2):
  ceph: libceph: move ceph_osdc_copy_from() into cephfs code
  ceph: add a new metric to keep track of remote object copies

 fs/ceph/debugfs.c               |  3 +-
 fs/ceph/file.c                  | 78 ++++++++++++++++++++++++++++-----
 fs/ceph/metric.h                |  8 ++++
 include/linux/ceph/osd_client.h | 19 ++++----
 net/ceph/osd_client.c           | 60 ++++---------------------
 5 files changed, 94 insertions(+), 74 deletions(-)

