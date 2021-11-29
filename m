Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30A44622FD
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Nov 2021 22:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhK2VNZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Nov 2021 16:13:25 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:37570 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhK2VLY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Nov 2021 16:11:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 309BACE13E1
        for <ceph-devel@vger.kernel.org>; Mon, 29 Nov 2021 21:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C99C53FAD;
        Mon, 29 Nov 2021 21:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638220083;
        bh=DK47Wf33UF0qzoXghMPn74HsMKyn2TnbZzsZzSfhdbs=;
        h=Subject:From:To:Cc:Date:From;
        b=egOuElKrNg7pVANc5sBJ8CiyG/hvSXXJGubJDoQSxLSmvXS/rQo0u0WVyxg66WFbl
         eZPugJS/cis30g7Fpyip98fpL3g9Pd59xDbcrdgo5fFZAF03J+qvvsr7TZvvcpBqEl
         oGf7H4mazNnSsGM78GWGA2d72wzOTKWb4BGS037iIQNFh2Du8B4BgtEyutC+2c/LLx
         mknR/Bzm/0RUR1fORxw8BQToAWJaAqN0XGg4r3vEcNBZ2ic5ik5r6L2i3mgdzsV8nT
         en4AixZRqgIUFaj4x+3hYT1UoBoMgLoiNOZYhk0TOzRqclPcofgulNjHndp5uhHGNX
         DK6hkQSXE0wHw==
Message-ID: <7e6c95bbb274b701e66432e56617ee9f91ce5012.camel@kernel.org>
Subject: Testing the Linux Kernel CephFS Client with xfstests
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel <ceph-devel@vger.kernel.org>
Cc:     ymane <ymane@redhat.com>, David Howells <dhowells@redhat.com>
Date:   Mon, 29 Nov 2021 16:08:01 -0500
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I had a few people ask me about how I do my testing with xfstests. This
blog post should cover the basics of how my test environment is
configured:

    https://jtlayton.wordpress.com/2021/11/29/testing-the-linux-kernel-cephfs-client-with-xfstests/

Questions and corrections are welcome. I'll also plan to update the blog
post if anything in there is wrong.

Cheers!
-- 
Jeff Layton <jlayton@kernel.org>
