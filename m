Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE3ED7A5C4
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2019 12:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732431AbfG3KOV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Jul 2019 06:14:21 -0400
Received: from mail-ot1-f51.google.com ([209.85.210.51]:38764 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfG3KOV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Jul 2019 06:14:21 -0400
Received: by mail-ot1-f51.google.com with SMTP id d17so65738406oth.5
        for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2019 03:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=9+iZXr3b6tF6Q6w3+3/xVvXjXviJkcj6wOyrw/jcZgU=;
        b=SU39ssxoVjbC+WZukLYVZMrCaZhOKGgBLng3FejYJSEhQ2fCFDnYSfR91DBVblmGt7
         38uJ9NswAQity471wkblgmD7KB2jgODMR7it96bev787FVOdZhvAD1yz8GWg9YcS42RT
         Ob8SxZFESAx5FnnLXGu14/Fc0JPXwisOJGLaIeMdX9hxrLkWUFCgbYHdk1QmnYFcWOBR
         6H+TxRkEEri82CUMyQebzNjQXFimLULUJ7UuZmbOWqr8Cqebh2/k096oDEaCirS6JyGQ
         4BwYVM15kPRKw4miS2wPqvHUaBJFA7YAIAXq0XxF/2G9+Fye2pZF6UdgV6VbjdeV3TRl
         mZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9+iZXr3b6tF6Q6w3+3/xVvXjXviJkcj6wOyrw/jcZgU=;
        b=UGieaw6kcWg9zAi8y0yxCdgAo13AKTWHfnRjM2hG/LpnP/KAePV/njjaBQppe1D0l7
         6Zs/x8fTKRKDw3GH+PSVdJo2Rm+sVrTsCfO2zx7NDfpug3HtXb+Io+2DV7d0N07cbCe+
         iiPv9DrnmtI/9fHYL+itjtS3UXLY26pDAQnxqppyyVFh9FkIZjEyYeAKlaoPz03OjzTr
         JlfPALniyCrw/UJQPpXx0ibJab4/wBx0rRnauB+CJF+8ERaDWA0meiCg8CJO8BvLSweZ
         TScaV7gUOHj/qDY/3CBVSE48nnGy/oKyEqivLVf9xcTs4QYYh00nNd3dJh1w4YyKicKJ
         xwLQ==
X-Gm-Message-State: APjAAAXEZjjkPmKJ4lAJT7JxRR1PytzhHi6M6gc2T5h06edlkkUGmid8
        +E+bWUIXlHwflRSnmzeAFNOfvPzo+Byqt9aKJmgsh0rs
X-Google-Smtp-Source: APXvYqwvFBg+/P59qtOAuxAZqThRvoVRjRwSAv6L6yhbN6mi+RSHdgyJX+S25ED6VVqISgF/66e9CpSEI431jbEF6Xo=
X-Received: by 2002:a05:6830:18a:: with SMTP id q10mr81285499ota.114.1564481659692;
 Tue, 30 Jul 2019 03:14:19 -0700 (PDT)
MIME-Version: 1.0
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Tue, 30 Jul 2019 18:14:05 +0800
Message-ID: <CAKQB+fuXv+Q9uPg35GmOmHF=+s1Z9+pFcy05ByfDYEL=LYkpPg@mail.gmail.com>
Subject: ceph-mgr: failed to retrieve mon information and exception shows
To:     branto@redhat.com, Sage Weil <sage@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

We setup a 3 node cluster (v13.2.4) with 3 MON running and encountered
a strange issue that mon metadata cannot not be retrieved from the
restful API mon endpoint but the "ceph mon metadata" command shows
correctly.  Under such condition, a exception shows as below when
accessing the mon endpoint.

<title>500 Internal Server Error</title>
<h1>Internal Server Error</h1>
<p>The server encountered an internal error and was unable to complete
your request.  Either the server is overloaded or there is an error in
the application.</p>

2019-07-30 17:28:22.539 7fd52a2ef700 -1 mgr get_metadata_python
Requested missing service mon.Host3
2019-07-30 17:28:22.550 7fd52a2ef700  0 mgr[restful] Traceback (most
recent call last):
  File "/usr/lib/python2.7/site-packages/pecan/core.py", line 570, in __call__
    self.handle_request(req, resp)
  File "/usr/lib/python2.7/site-packages/pecan/core.py", line 508, in
handle_request
    result = controller(*args, **kwargs)
  File "/usr/lib64/ceph/mgr/restful/decorators.py", line 35, in decorated
    return f(*args, **kwargs)
  File "/usr/lib64/ceph/mgr/restful/api/mon.py", line 39, in get
    return context.instance.get_mons()
  File "/usr/lib64/ceph/mgr/restful/module.py", line 500, in get_mons
    mon['server'] = self.get_metadata("mon", mon['name'])['hostname']
TypeError: 'NoneType' object has no attribute '__getitem__'


Also, lots of "unhandled message" spams the syslog of active MGR (on Host2):

2019-07-30 17:28:22.936 7fd52caf4700  0 ms_deliver_dispatch: unhandled
message 0x55e44f783800 mgrreport(mon.Host3 +53-0 packed 798) v6 from
mon.? 192.168.2.118:0/612
2019-07-30 17:28:23.447 7fd52caf4700  0 ms_deliver_dispatch: unhandled
message 0x55e44f54d200 mgrreport(mon.Host1 +53-0 packed 798) v6 from
mon.2 192.168.2.202:0/1967658


After raising the debug_mgr from 1/5 to 20, it seems that the there is
no MON metadata recorded in the DaemonState so that any further update
are ignored.

2019-07-30 18:04:50.784 7fd52caf4700  4 mgr.server handle_open from
0x55e44de6aa00  mon,Host1
2019-07-30 18:04:50.786 7fd52caf4700  4 mgr.server handle_report from
0x55e44de6aa00 mon,Host1
2019-07-30 18:04:50.786 7fd52caf4700  5 mgr.server handle_report
rejecting report from mon,Host1, since we do not have its metadata
now.
2019-07-30 18:04:50.786 7fd52caf4700 10 mgr.server handle_report
unregistering osd.-1  session 0x55e44d219ba0 con 0x55e44de6aa00
2019-07-30 18:04:50.786 7fd52caf4700  0 ms_deliver_dispatch: unhandled
message 0x55e4509b4600 mgrreport(mon.Host1 +53-0 packed 798) v6 from
mon.2 192.168.2.202:0/1967658

I tried to restart the MON and MGR on Host1 but the "unhandled
message" logs still keep showning on the active MGR.  Is there any
idea to fix or to remove the "unhandled message"?  Is it related to
the inconsistent mon metadata issue?  Thanks.

- Jerry
