Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9281A1D9811
	for <lists+ceph-devel@lfdr.de>; Tue, 19 May 2020 15:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbgESNno (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 May 2020 09:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbgESNno (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 May 2020 09:43:44 -0400
Received: from mxb1.seznam.cz (mxb1.seznam.cz [IPv6:2a02:598:a::78:89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D0DC08C5C0
        for <ceph-devel@vger.kernel.org>; Tue, 19 May 2020 06:43:43 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc24b.ko.seznam.cz (email-smtpc24b.ko.seznam.cz [10.53.18.33])
        id 37ba8706ea855e883720c176;
        Tue, 19 May 2020 15:43:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1589895822; bh=ClhOKMJFOhReqsq49WZKzuscRV7vI9yvbDp6boDT9ps=;
        h=Received:From:To:Subject:Date:Message-Id:Mime-Version:X-Mailer:
         Content-Type:Content-Transfer-Encoding;
        b=b8DjaIAFpHmPSxd9KnyMcD5WOBCgN+dGIa/SA4Khkhs8+R9AKJhK61NnUMkpTHD2q
         xGw4+bhv0kxuz4dNAi5C2KgBYklRWf6ebn6iRrLXQgWec/WlE0W3wJMEfNnBUj5LTw
         dkK/zTmSTudBCGJ9jrVJOacWyzdSL0nGO+IMvXXk=
Received: from unknown ([::ffff:88.146.49.155])
        by email.seznam.cz (szn-ebox-5.0.29) with HTTP;
        Tue, 19 May 2020 15:43:40 +0200 (CEST)
From:   <Michal.Plsek@seznam.cz>
To:     <ceph-devel@vger.kernel.org>
Subject: ceph kernel client orientation
Date:   Tue, 19 May 2020 15:43:40 +0200 (CEST)
Message-Id: <6n.cjI5.4P7G519BQ1k.1Um{AC@seznam.cz>
Mime-Version: 1.0 (szn-mime-2.0.57)
X-Mailer: szn-ebox-5.0.29
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

I am trying to get to functions responsible for reading/writing to/opening=
 RBD blocks in ceph client kernel module (alternatives to librbd=E2=80=99s=
 rbd_read(), rbd_write() etc.). I presume it should be located somewhere a=
round drivers/block/, but until now I=E2=80=99ve been without luck. My ide=
a is to edit these functions, rebuild the ceph kernel =E2=80=98rbd=
=E2=80=99 module and replace it. Since comments are pretty much missing ev=
erywhere, it would be nice to narrow my searching area.

If you know anything about it, please let me know. Thanks, M. 
