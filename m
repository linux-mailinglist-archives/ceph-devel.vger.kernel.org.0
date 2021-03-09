Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA35332F1C
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Mar 2021 20:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhCITgg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Mar 2021 14:36:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230462AbhCITgX (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 14:36:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79DF06157E;
        Tue,  9 Mar 2021 19:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615318582;
        bh=NGrEEFfMDG1tXLjTW6mhuN+sDKD9iqKG/nidEW4F80M=;
        h=Subject:From:To:Cc:Date:From;
        b=R3yatCrGmAeJ61JFEbET1UfPrUmF2lbymH+mP2oKvBUcMB5plKUkGCrsmndJ/BGx4
         CwSJNW22cMxIZPp0WWB2KkY6WeesRUKTwfTqBqkky9enM7eWd0kECxQHomD4IvEA04
         ErtDFA9lFFhgByO9VHNMAH9O3A/uebMRcetCdzbCdK5e/63BHvHCvP+HwR4Yw9zr8v
         XZ8Gbd5ZiPH+O3rO8LIlHWU4pFTAp1BTeNgfD+N7vunLjqcRiqyDe+V0J7h1W5Zg0u
         pp2AuAW9VjJ17QPQ8+byBdFqjRG9V6s5XrvcE96kuuuMBvWod6fUuUobzl1pNBtBET
         YqzhshOY1+eMw==
Message-ID: <ac3703b3b382cc6e947904238e3dc4c671eb7847.camel@kernel.org>
Subject: ceph-client/testing branch rebased
From:   Jeff Layton <jlayton@kernel.org>
To:     Ceph Development <ceph-devel@vger.kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 09 Mar 2021 14:36:21 -0500
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Just a heads-up that I've rebased the ceph-client/testing branch onto
David Howells' fscache-netfs-lib branch (which is itself based on top of
v5.12-rc2).

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

