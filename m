Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F76A138C99
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jan 2020 09:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgAMIER (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jan 2020 03:04:17 -0500
Received: from mail01.vodafone.es ([217.130.24.71]:56609 "EHLO
        mail01.vodafone.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728695AbgAMIER (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Jan 2020 03:04:17 -0500
IronPort-SDR: +IPYwp2WF8/42bsZDhgMxqF1P12U0BqkwS7GGTHPJ4Bw2YgXKhCYT1Bk26FhJ7d36IGAb9GUSx
 QoRW4UxPAumg==
IronPort-PHdr: =?us-ascii?q?9a23=3ALYCvwhTFsh2y0tDESExA0bZUWtpsv+yvbD5Q0Y?=
 =?us-ascii?q?Iujvd0So/mwa6ybReN2/xhgRfzUJnB7Loc0qyK6vumAzJRqs/Y7jgrS99lb1?=
 =?us-ascii?q?c9k8IYnggtUoauKHbQC7rUVRE8B9lIT1R//nu2YgB/Ecf6YEDO8DXptWZBUh?=
 =?us-ascii?q?rwOhBoKevrB4Xck9q41/yo+53Ufg5EmCexbal9IRmrowjdrNcajIpmJ6o+1x?=
 =?us-ascii?q?fFv3pFcPlKyG11Il6egwzy7dqq8p559CRQtfMh98peXqj/Yq81U79WAik4Pm?=
 =?us-ascii?q?4s/MHkugXNQgWJ5nsHT2UZiQFIDBTf7BH7RZj+rC33vfdg1SaAPM32Sbc0WS?=
 =?us-ascii?q?m+76puVRTlhjsLOyI//WrKjMB8i79Vrw67qBx6w4/YeZ+YNP1kfqPFetMaX3?=
 =?us-ascii?q?BOXtpPWCBYHIy8aZIDAvYdPeZEtYbyu1sOogW7BQayAuPv1iZEiWHw3aEj1O?=
 =?us-ascii?q?ohFgfG0xIgHt4XrnvUqsj+OKMcXOyp0KXEyDPOZO5U1zjg8ojFah4vr/GWXb?=
 =?us-ascii?q?xucsTf1EYgGB/KgFiLtYzoPS+a2vgRv2SH8eZtU/+khW49qwF2pzii3t0ihZ?=
 =?us-ascii?q?fVho0L0FDP6CV2wIEzJd23VUV2ZsakH4VMty6ELYt3TMQiQ2dnuCshyr0Goo?=
 =?us-ascii?q?W0czQQxJs7wB7fbuaLc4iL4h/6UuuaPDR2hGp9db6hmhq/81KsxvDyW8Woyl?=
 =?us-ascii?q?pGsCVInsPCu30N0RHY99KJReFn/ki73DaCzwXT6uZZLk8qjafbMJshwqIolp?=
 =?us-ascii?q?oUrETDAjf6mEXog6+ScUUp4u2o5P7mYrXivJ+TKYt0hh3xP6g0hMy/Bvk3PR?=
 =?us-ascii?q?IAX2ic/+Szyqfv8lPiQLlSj/02lLfWsIzCKMgFu6K0ARVZ3pst5hqjFTuqzt?=
 =?us-ascii?q?sVkWMJIV9FYB6HipLmO1DKIPD2F/e/hFGsnS9zx//YIr3uHI/NL3bEkLfncr?=
 =?us-ascii?q?Zw8E5cyBEowt9D/Z5bFrYBIPfpVk/xt9zUFgU5PBCsw+b7FNV90ZsTVn6RDa?=
 =?us-ascii?q?+BMKPeqEKH6fwxI+aSYI8Yoyj9K/c76P70l3M5mkESfbOv3ZQJbHC0BPNmI1?=
 =?us-ascii?q?+WYSmkvtBUGmoSvk8yQfLnjHWcXjNJIXW/RaQx4nc8Eo31N4rbQpGRh+m50T?=
 =?us-ascii?q?u2BNVpYWZJQgSUHGvlbZqDXfgMayKJKMRJnTkNVLznQIgkg0KArgj/noJqMu?=
 =?us-ascii?q?fOshIfs52rgMB4++DJihY0+hR0FM6WlWqKSid0nTVbFHcNwKljrBkkmR+42q?=
 =?us-ascii?q?9ijqkDTYRe?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2EGEgC7IxxeeiMYgtkUBjMYGgEBAQE?=
 =?us-ascii?q?BAQEBAQMBAQEBEQEBAQICAQEBAYF7AgEBFwEBgS6BTVIgEpNQgU0fg0OLY4E?=
 =?us-ascii?q?Agx4VhggTDIFbDQEBAQEBGxoCAQGEQE4BF4ESJDoEDQIDDQEBBQEBAQEBBQQ?=
 =?us-ascii?q?BAQIQAQEJDQsEK4VKgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKTAEOAVOFTwE?=
 =?us-ascii?q?BM4UolzgBhASJAA0NAoUdgjUECoEJgRojgTYBjBgagUE/gSMhgisIAYIBgn8?=
 =?us-ascii?q?BEgFsgkiCWQSNQhIhgQeIKZgXgkEEdolMjAKCNwEPiAGEMQMQgkUPgQmIA4R?=
 =?us-ascii?q?OgX2jN1eBDA16cTMagiYagSBPGA2WSECBFhACT4kugjIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2EGEgC7IxxeeiMYgtkUBjMYGgEBAQEBAQEBAQMBAQEBE?=
 =?us-ascii?q?QEBAQICAQEBAYF7AgEBFwEBgS6BTVIgEpNQgU0fg0OLY4EAgx4VhggTDIFbD?=
 =?us-ascii?q?QEBAQEBGxoCAQGEQE4BF4ESJDoEDQIDDQEBBQEBAQEBBQQBAQIQAQEJDQsEK?=
 =?us-ascii?q?4VKgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKTAEOAVOFTwEBM4UolzgBhASJA?=
 =?us-ascii?q?A0NAoUdgjUECoEJgRojgTYBjBgagUE/gSMhgisIAYIBgn8BEgFsgkiCWQSNQ?=
 =?us-ascii?q?hIhgQeIKZgXgkEEdolMjAKCNwEPiAGEMQMQgkUPgQmIA4ROgX2jN1eBDA16c?=
 =?us-ascii?q?TMagiYagSBPGA2WSECBFhACT4kugjIBAQ?=
X-IronPort-AV: E=Sophos;i="5.69,428,1571695200"; 
   d="scan'208";a="304681471"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail01.vodafone.es with ESMTP; 13 Jan 2020 09:04:13 +0100
Received: (qmail 28790 invoked from network); 12 Jan 2020 05:26:37 -0000
Received: from unknown (HELO 192.168.1.3) (quesosbelda@[217.217.179.17])
          (envelope-sender <peterwong@hsbc.com.hk>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <ceph-devel@vger.kernel.org>; 12 Jan 2020 05:26:37 -0000
Date:   Sun, 12 Jan 2020 06:26:37 +0100 (CET)
From:   Peter Wong <peterwong@hsbc.com.hk>
Reply-To: Peter Wong <peterwonghkhsbc@gmail.com>
To:     ceph-devel@vger.kernel.org
Message-ID: <25970796.544078.1578806797717.JavaMail.cash@217.130.24.55>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Greetings,
Please read the attached investment proposal and reply for more details.
Are you interested in loan?
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

