Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134B5540231
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 17:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343889AbiFGPOj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 11:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239925AbiFGPOg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 11:14:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40C4694AF;
        Tue,  7 Jun 2022 08:14:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5A3CD1F9BA;
        Tue,  7 Jun 2022 15:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654614873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aKU3mt5p7MVwd3/TPJR+W8rtwQibChtPTI7gFQcRZIA=;
        b=Prmh4wfcQ/tCCz4qfGt0CvfsTYWuw8pAR1XOiUe5H63W4MILAHpWsRZObOdfAG1cyZl3zc
        JeSwtJYhgsWg9FRijvCSV10rxLNx96iUB/8Ytpx/zhQvBOTZ2g8r2q52tLBx8cxjb1cYmF
        3zbWsl2E/dsMO+ZM4t4uE4sCaR53fjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654614873;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aKU3mt5p7MVwd3/TPJR+W8rtwQibChtPTI7gFQcRZIA=;
        b=JLgrHbbi+hWEnMk1SPh1ETOAW82Y3pdEFeVZ/xT/xRF0Ip9mHP2KPGdDyAQb2iYLQjf1JT
        r1cel98rRahQDoCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E118B13A88;
        Tue,  7 Jun 2022 15:14:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HoKyM1hrn2JRWwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 07 Jun 2022 15:14:32 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id a92bbfb7;
        Tue, 7 Jun 2022 15:15:14 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     fstests@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH 0/2] Two xattrs-related fixes for ceph
Date:   Tue,  7 Jun 2022 16:15:11 +0100
Message-Id: <20220607151513.26347-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi!

A bug fix in ceph has made some changes in the way xattr limits are
enforced on the client side.  This requires some fixes on tests
generic/020 and generic/486.

Cheers,
--
Luís

Luís Henriques (2):
  generic/020: adjust max_attrval_size for ceph
  src/attr_replace_test: dynamically adjust the max xattr size

 src/attr_replace_test.c | 5 ++++-
 tests/generic/020       | 9 +++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

