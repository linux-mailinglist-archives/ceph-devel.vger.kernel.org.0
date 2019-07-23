Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4F97231F
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2019 01:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfGWXgZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Jul 2019 19:36:25 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:52930 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbfGWXgY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 23 Jul 2019 19:36:24 -0400
Received: by mail-wm1-f53.google.com with SMTP id s3so40052755wms.2
        for <ceph-devel@vger.kernel.org>; Tue, 23 Jul 2019 16:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=aksjDbqrZFBPxdYlX9+cSSWXZs89mLNxMEMQ3PufZiM=;
        b=A0hSTieLt3MfED0W/HAPN7j61hK+7haCUDRwJ9hW6fh798jztoN8sB79PMGgpCYPQt
         kd3AK8G8RksLsG+gPOPGGcu7Hq4jtSXsbffx2QJ1bjRfNDMcvd5yPHm9MyKLobPbUZ3h
         Xztid41cQz42kiS31wwQYeG+ZNCOREiVBYdUW0X03k/+Et4jXP5e2wYI0EJdoFkiTC1Z
         Ds0tLN8o9BoXuZakkp/kUKjNHLTXH5o9UESnXldZScl7ML3FnmiLwJ3IHKb45vD0ofVh
         Mvt3rpokAjajmOuWIl3XYCujO7bp8Dl9qMdynrehY2pz5xXXaU9lIHL7+wY3dOqif0l7
         mQlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=aksjDbqrZFBPxdYlX9+cSSWXZs89mLNxMEMQ3PufZiM=;
        b=o3AnNbM+1B2bKcfQ0iA/Bhvb1da9sGr54cXDb4+Rk0nNuNYdVHQJpeSUW0XbIGnTis
         OIkaS7RXFL+HoJ+eyDpmTLuhZOebDtvt5TEzEUwoiqPZJbfjwWzLKJtnsM1j8hbIf48A
         K/YV8kzX/xZbEUrn8fqdiF06gZPgyHeqq4QS+jA+wkHKlR0aK0YC3uBejlsSKFhFntPx
         OCWwG+fYwjh1IQqjr3EMHD8zfWst0ErA2hIerFZPNmkzciojqMAEHo3u3QI7l2NfjNkA
         XMPBMYIYTzXIk11mXaHFxV4FD+gMTr9kmc7x1an9ySxOnv8NWQq9eivNGBEcmLU9xhfH
         zJNA==
X-Gm-Message-State: APjAAAWaz77FSron5sHbSfURL+K0zqQTfl30d5TxOn8ObnoNcrnph/ys
        HVvz7ypBM0/1i8KRZhJfTw9Ri6QdfPbHHpd6SMx+2tP7
X-Google-Smtp-Source: APXvYqyEiqS1iXiSWtNfetM4FM3tpj9qfBDGdy+e3VDhNtn1zL+t34v9euO/I6YztuLNBlKGfqTK/uFOUttXfD+TAbo=
X-Received: by 2002:a7b:c104:: with SMTP id w4mr73510984wmi.42.1563924982528;
 Tue, 23 Jul 2019 16:36:22 -0700 (PDT)
MIME-Version: 1.0
From:   LV <laurentiu.v@gmail.com>
Date:   Tue, 23 Jul 2019 16:36:11 -0700
Message-ID: <CAM8WQDujKaFS4DDPGgf084jXPXUC5pWGAB29Rx8eab9=cPAhjg@mail.gmail.com>
Subject: ceph monitors crashed/unrecoverable
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

i'm trying to follow your troubleshooting steps from:

http://docs.ceph.com/ceph-prs/17023/rados/troubleshooting/troubleshooting-mon/#recovery-using-osds

but it seems that i need to stop the ceph-osd process in order to do
that. Would it be possible to do it without stopping the process?
(it's in a pod that might get restarted if the process is shut).

Thanks.
