Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1761F5065
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jun 2020 10:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgFJIiK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 Jun 2020 04:38:10 -0400
Received: from mout.gmx.net ([212.227.15.15]:58897 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbgFJIiG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 10 Jun 2020 04:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1591778283;
        bh=AAyw6K3L1nVM2jF++8IVvqUOFDyON45CTMg1l39mfVc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=NlBghSVYKzNZq6WH8VN2DJs7tkLK6YYM6kuERFZezkndq8aW9lEUlbZyFmC+slrcx
         trkd+ASQQB6LU2O3LHVJMBznlCgMz/cMzpytbVZ+wLfLVCnI7CmIwzKGi/54+g7qVo
         RoIryRHE4qSbMY3+u3dq7yGTzJQxJvihIU5no9T4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.10.212.219] ([103.59.50.2]) by mail.gmx.com (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MWics-1jPDUp13MW-00X4CW; Wed, 10
 Jun 2020 10:38:03 +0200
From:   norman <norman.kern@gmx.com>
To:     ceph-devel@vger.kernel.org
Cc:     sage@redhat.com
Subject: Questions of QoS on ceph
Message-ID: <b8eca4d9-e368-0f35-f3dc-6049d9a213fd@gmx.com>
Date:   Wed, 10 Jun 2020 16:38:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:MwA28IrtqRTvjrlUek2qW/AxpIrHH51aQVZxtt61uNFFaMOhCZi
 H+cguikFmarfYKriUV+e0y0rNClScGmWZYReXtIdC3fIM38nKYFd+kiCPcwNmfN8XDYrUD6
 Gid5YAETs1E+SBWLQSEDz9KRciX4r031x15x8rzBwxazI1uz1Q0vB1y1CBRo/CcXQvg1hrG
 CoHBt+wfbs7ECOQh2TRXQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wTlw5klMuAs=:rnij3bgLVPn64L5Lk6uF9v
 E7YCLvJfQhCN3SMmr1MBRcXuhFLKH6Hza72tWRUCexiphh8aL6XZRQuHYWW3HkTt7KvAm1Nms
 eseauo9sCHfHkdbfDYYciWaOBDVaSjRVqXVEmJUUs7CG9tyI+JFVOKhY8CtGdVFFUVASZgmHs
 M0pJOtzqWE831yWdn1guxSXE0goGxUEkmTp7FgJmIqGBH20RUt1/CAbAxlr7wb7kVi/D36k/b
 fOZ76/Gn6IktDt1c1PU5NQ9+j/4avc0DHBOu0lImg+5dqlOKxCnRKS+Ttefhp8PKfPV9LL6qJ
 B1OdnP4XI/3rK7dUyVZN5JvpKGXMI4cyOiU9m3ruKRxag7AGzelPGAzUF39Vel5xPnuYEGzF6
 4/gF6fnimUCGadbt+m6EFHqOhX8MXeLN2kWfMwnhayugQd1GU0OzTOrn61+NxKPpn1BBaJ6P8
 LFiiiQQO2HrKDh6S1jCPHgzyZEX7zilmmE0DYalQsuHoHsZba8j4QCdwI9nM8insCeG2+/bos
 rsFWBlU8iIktasv3rgOd4dgHCfL4eKCjj5IycEtC2mvcDtuVmXSPE51+YhL7i1v57dQya0q+U
 YlQ8kq6S/Dk0OKbxAGvfEQwpB67Rz3TrBwwictNCIDqmspvKemSamIJjxpvQ4ZKUu7LO//vT/
 o3iR5exe1jTzCgRhToPPKQqoCZXOMglEot8ZWWOjjHfzB9PSf5IfPndgwPmCLh6jjSTJiGXtR
 /d76+NL/hHYKy9rrHBxncZ5vriCbYd23MlmEGOLmXqoMJ82TGp6sIpZHvw1uWgNWVU3aeLpe/
 IlAMOeRkydDTCQKDMu62G+7jE1sc/ker4XWXOWip6BvIcJaikObS0Xd0qEiuVvVplv7R9DQuJ
 fW5oYZS4nGqXgndmZ1Cbj0AoQ7CB8IRJyx2CozK3wUAHWk6k9ANo2YQMiGzAv1TNiThCimbR3
 Nl0oOWcQzZgkPuukbmPaXTPZl8CmlK0WILepdOs/b3c4nRMch0NUg/FYMaKR/h+Hv79eh+UJw
 9P8XxKob5c1EPskKN80WlZCS2aNnsfKjLzpRqObPHeCXizN/wvC72dMyiOBgQ8xsEGmHeQ7h1
 3X90rMmf2csODg4aIKazd9lL6YUaLcOsYcHwsBWfoTTxSawr1tZHbjKg9S900BFRLMV7cVrUl
 3ZPHU65gKg8ZyZackLgrBIRqnOCp7eHE4Q/sldcgcGO+HYtO3JGhZGxud93jFBVr8w6TZIuV3
 q+rAjPMZEKlawm68S
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi guys,

I want to setup a=C2=A0 ceph cluster for teams, using fs and s3 interface.=
 I
met a problem about the QoS: How can I limit the

bw or qps of a client to avoid the someone blocking others by running
lots of threads?

Best regards,

Norman Kern

