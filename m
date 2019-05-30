Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 430892FC9C
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2019 15:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfE3Nq5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 May 2019 09:46:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33356 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfE3Nq5 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 May 2019 09:46:57 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 94DD430C1211
        for <ceph-devel@vger.kernel.org>; Thu, 30 May 2019 13:46:57 +0000 (UTC)
Received: from ovpn-112-65.rdu2.redhat.com (ovpn-112-65.rdu2.redhat.com [10.10.112.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 46E5170498
        for <ceph-devel@vger.kernel.org>; Thu, 30 May 2019 13:46:57 +0000 (UTC)
Date:   Thu, 30 May 2019 13:46:56 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     ceph-devel@vger.kernel.org
Subject: iso8601 date formatting merged
Message-ID: <alpine.DEB.2.11.1905301346170.24522@piezo.novalocal>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 30 May 2019 13:46:57 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

https://github.com/ceph/ceph/pull/27799

Be on the lookup for date parsing/formatting issues in master.

sage

