Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9557B43E9D0
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 22:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhJ1UpX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 16:45:23 -0400
Received: from pop3.jakarta.go.id ([103.209.7.13]:21971 "EHLO
        mail.jakarta.go.id" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbhJ1UpW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Oct 2021 16:45:22 -0400
X-Greylist: delayed 14413 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Oct 2021 16:45:22 EDT
Authentication-Results: mail.jakarta.go.id; spf=None smtp.pra=ses.nakertrans@jakarta.go.id; spf=PermError smtp.mailfrom=ses.nakertrans@jakarta.go.id; spf=None smtp.helo=postmaster@zmtap2.jakarta.go.id
Received-SPF: None (mail.jakarta.go.id: no sender authenticity
  information available from domain of
  ses.nakertrans@jakarta.go.id) identity=pra;
  client-ip=10.15.39.86; receiver=mail.jakarta.go.id;
  envelope-from="ses.nakertrans@jakarta.go.id";
  x-sender="ses.nakertrans@jakarta.go.id";
  x-conformance=sidf_compatible
Received-SPF: PermError (mail.jakarta.go.id: cannot correctly
  interpret sender authenticity information from domain of
  ses.nakertrans@jakarta.go.id) identity=mailfrom;
  client-ip=10.15.39.86; receiver=mail.jakarta.go.id;
  envelope-from="ses.nakertrans@jakarta.go.id";
  x-sender="ses.nakertrans@jakarta.go.id";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 a mx ip4:103.209.7.13
  include:_spf.google.com include:_spf.mail.yahoo.com
  include:spf.smtpid.jakarta.go.id ~all"
Received-SPF: None (mail.jakarta.go.id: no sender authenticity
  information available from domain of
  postmaster@zmtap2.jakarta.go.id) identity=helo;
  client-ip=10.15.39.86; receiver=mail.jakarta.go.id;
  envelope-from="ses.nakertrans@jakarta.go.id";
  x-sender="postmaster@zmtap2.jakarta.go.id";
  x-conformance=sidf_compatible
IronPort-SDR: elRDFDGs+7Ul0eya8of9jVQIMhd2DvrN1RI4vE/ItbmePtHKr6welbF/cANTBcod4g7o8vBML7
 SnOAv4Da2nQQ==
IronPort-PHdr: =?us-ascii?q?A9a23=3Axo8SdxSG3pv/t9ix+oElJKVpv9psol+ZAWYlg?=
 =?us-ascii?q?6HP6ppLe6WnuZbrP0XF+fwrg1iPXImIo+lchb/wtKbtEXcF/Y7HqGoLJYdBT?=
 =?us-ascii?q?FkDgMYbhRA6CcieIU/yL/fwcyV8E8MEVVM2t2qjPx1tFdz7SkfIpWf69jsOA?=
 =?us-ascii?q?lP6PAtxKP7yH9vJgt/x0emx9ofPeQxOnxK/aLB7Ngm/6wrW8Mga0sN5Mqhk7?=
 =?us-ascii?q?BzPrzNTfvhOg2NlIVXGhxHn+sK554Ju6QxCvu4o75QGU6z5dr4kRPpXC3InP?=
 =?us-ascii?q?wjZ/eXNsh/OBUuK73oYFGcfkRNSHwGD4xa8X5uj+i39/vFw3iWXJ4X/UKw0V?=
 =?us-ascii?q?DK+7qxqVA6N6m9PNjg393vSg9Bxi6QTqQyophh2yYrZKI+PM/82cqTYdNIcD?=
 =?us-ascii?q?W1PO6QZHzdMGcW6ZogCFfYbNOBDh4v0pFIUsRL4Cg7qBe+ugj5Ei3nq3LErh?=
 =?us-ascii?q?vw7GFKjvkRoFNYPvXLI6dTtYf5KF7noivKZi2WdPLtM1Dzw6ZbFaEUkqPCIG?=
 =?us-ascii?q?7B5csPL1UBpGASDj1nDzO6tdz6TyOkJtHCWquR6Uuf6wXUqsEd3qzui3Ns2g?=
 =?us-ascii?q?4/SroAcyVne6Sw/z4FzJNHyGysZKZa0VYBdsS2XLd48Wc45BWdhuysg1qcPv?=
 =?us-ascii?q?4WTfiEJwY47zljQbLqGf8Lbh3CrHPbUKjB+inV/fbu5jBvn6kmsxNr3Ucys2?=
 =?us-ascii?q?UpLpC5I+jXVnkgAzRn+8NKAULM9+06g3XCN3gPa8P1NZ08z06vXedYqy7g2k?=
 =?us-ascii?q?YZbukPZBCL9hEHn6c3ePkQi5uWy8/7qfv39q5mQOpU8gxziMqkohs20APgpe?=
 =?us-ascii?q?gkIUW+B/O2g1brltUPjR7ACgvozm6jf+JfUQKZT7rW0GElT24Uu8QqlBjG9+?=
 =?us-ascii?q?NYRnnAdMFsDdxXBjoSoc1DCLfbkDOuu1lGlkTNl3ffDbdiDSt3GKnnOlqukf?=
 =?us-ascii?q?K4oshYakVd1loEZt8wHQqsMK//yRELr4dnRDxt/MQW3yvz7AZNy0cUfVTHqY?=
 =?us-ascii?q?OfRPaXMvFuP/u9qLfOLYdpfozvmbf4s5PP0kWUwn0Q1f6Cq1IELYTa3GbJnL?=
 =?us-ascii?q?w/KBBikysdECmoMsgckGabxhUbEVzdQamyuRas6/Rk5AYGvF5vKAI+qxr2Nl?=
 =?us-ascii?q?nTefNUediVNDVaCFm3tfoOPVqIXaS6cFcRmlyQNSbmrT4JynQHrrgLxzKBra?=
 =?us-ascii?q?/bF4iBN/4y2z8B7vqeA8HN6vSwxFcmW1HuBCn15jn9dDSFjx7hx+AR0glKTm?=
 =?us-ascii?q?alg364BTYcVvasYFFh8bMW5raQyCtb5Xh/Nc4W+U06oBNqhBj41Q5Q6xNpGY?=
 =?us-ascii?q?kB2H8iug0L0xDKkRboclrjNFZU09aWa1H/0QqQ1g3fA3608g1R0WdNBc3ajm?=
 =?us-ascii?q?rZ++07RDo3AiVmQ0amtM6UQlDjE8GPJpYaXlGdfVgM4EaDMXHRZZELVpM7l7?=
 =?us-ascii?q?wXNSPmvBeZvNAwJ0sOEJqZQItT0kVVLQuviM9XCcgfT0y+xAxiP3LaFcIvtf?=
 =?us-ascii?q?S0UwizcDEEOlw1b82yBMEAyASKoomSWCzILdxqne0T37ex3s2+2VGcmyh2Dd?=
 =?us-ascii?q?xcn1bO28wQJjLqTTLUS0vNMuSssrSl1AEfo39/SDInlxUIpd6FdbNUhpVZfg?=
 =?us-ascii?q?DuB8VUgeMfxafA81RYEfg96vl3jzUByA4RE18ojr3ow0AM0JqXe0V8SElHQl?=
 =?us-ascii?q?Z32JLDTLXH/uR61bKuDkErTy5CQ86QC8ugiolP4lAOgFUM473wh3N4T0nfWt?=
 =?us-ascii?q?fCoREICFIn8VEo67U0wv7bBfiw0/J/Zz1V+NLW9qmWE2dsqDfE5w1CveJFeP?=
 =?us-ascii?q?OnXcW26W91fDM+oJuswnlGvZR9RJ+Fe+pk/OMa+fueH0qqmVA6BtCCjkW1fu?=
 =?us-ascii?q?sZ/20GF7TZ1DOHPmZcJkanwNu6vVT7/hU29u4b4nsZFaWNKdoJQ4SrtB4dLe?=
 =?us-ascii?q?qQ0coFNCGv8faWK?=
IronPort-Data: =?us-ascii?q?A9a23=3AAucpAa2+SkNNciIBIvbD5dJ0kn2cJEfYwER7X?=
 =?us-ascii?q?KvMYLTBsI5bpzBVzDMaXmuCaK2PYGPze9skYNzl8U4G7JTXnd5kSwRs3Hw8F?=
 =?us-ascii?q?HgiRegppzi6BhypY37NdJ2roHqKWKzyU/GYRCwPZiKa9kjF3oTJ9yEmjPjQH?=
 =?us-ascii?q?OqkUoYoBwgoLeNaYHZ54f5cs7Nh6mJYqYDR7zKl4bsekeWGULOW82Ic3lYv1?=
 =?us-ascii?q?k62gEgHUMIeGt8vlgdWifhj5DcynpSOZX4VDfnZw3DQGuG4EgMmLgpqIWzQw?=
 =?us-ascii?q?4/Xw/stIovNfrfTYEgWS6aIewqHiXNMR6HkjR8EpyBaPqQTbaJaMBoR0GTPz?=
 =?us-ascii?q?44ZJNZl7PRcTS8yM7aKnu0eXgNECSh4JoVE8bzOO2S298OUiUzKG5fp66w0X?=
 =?us-ascii?q?B9nYdBDkgpwKSQUnRACExgGYwyOr/+xxPSwTewqjN5LBMLmII4as3V8wTjxE?=
 =?us-ascii?q?PEiB5vERuPA/7dw1zosnMlIBu72es0dLzFoaVLKeXVnMVoJA4gjjs+1gX25e?=
 =?us-ascii?q?Dpd7liPzYI87nbeyAh4+KXqNJzefdnMT989tk2VuGXx5G7yKgwdMJqUzj/D+?=
 =?us-ascii?q?GjEruTCjyrhHokVEqGx+vlwqECUwioYDxhQX0HTifK0mEekHcpeMUEP0jcpq?=
 =?us-ascii?q?e4580ntRMOVdxa1sneesBcGWtxZGOw9wByKzuzf5APfDHJsZjVPLtgrscgtb?=
 =?us-ascii?q?SEt0hmCmNavDyYHmLabQGic8LqQqTKaJC8Ra2QFYGkOV2Mt6Nfqu5oylVTVQ?=
 =?us-ascii?q?9BqDKedk9rxXzr3xnaAtkAWjLsaltUKzOOg+lvGijaEu5/NCAUy40PdRAqN5?=
 =?us-ascii?q?Q1wf5WkfKS17lyd5vFFaoyDJnGKsnNBgMGU9uEIBLmQkyjLS+IIWruzj96OP?=
 =?us-ascii?q?jDdjERHAp4lsT+q/jipZ+h46z9zPl1kM8IsZDjtJkTUvEVb/vd7N3Wnd7V6Y?=
 =?us-ascii?q?pi4Asg05bXnEZLuUfWSZMAmSpN8bB6v4TpnI0WX2gjFm0Yli6ckJpCBbcaEE?=
 =?us-ascii?q?G0TCKghwz2oL88W3K837j0lzGeVSIuT5x+q1LOSZXuSYaoeMh2DYv1/6Knsi?=
 =?us-ascii?q?A7Y9t9aH9aRyVNSXPC4ZiO/2YUeKUERIHUTGIz77cNQa/DFIhYOMGosDePLy?=
 =?us-ascii?q?LcJZYVmlqdUjaHH5BmVUUJC0l36iFXZJB+LeHdlLrXiQf5Xpn8jPWkgMEil3?=
 =?us-ascii?q?1A9bou1qqQSbZ06ef8g7uML5fV5VPAfU9uBC+5CRnLM/DF1RZLwqpB4eTy1h?=
 =?us-ascii?q?AuSMiHjbiJXV5VtQCTX+9T4eRHu/ScPCCOxvsZ4qLrmyhGzaZEOQRh4AYDdY?=
 =?us-ascii?q?e6vwkmwu3U1huN+UkzUON5VPk7lmKBhJirtlPI3Kt8WJD3dxzeX0BqMBhFer?=
 =?us-ascii?q?uCli4Q49sXTiKWFtJyoFO13H1BXN3fa4buxKTPd+CyoyOdoW+uOYSrQU3no+?=
 =?us-ascii?q?KK6aOlU1uzxPPcvgldGvo1gCbFti6k3j/PkqqRTzx5pHl3VblimDa96JX/A1?=
 =?us-ascii?q?sAnnqZA2qVUjga8V0SC6NRAEauINM7iDEQWIkwuZ4yr3vwShiPfq/8oJFnn/?=
 =?us-ascii?q?iJz1KSGVUFfMxSCjypBJbpzPcUvzI8Js8MR5Em0jDI0M87AlSFS/iKHKXloe?=
 =?us-ascii?q?64qsJobCYnnohQq0F5DZZ3bTC7qiLmEZtNQKE4hKzqRjbDLm7102EvYfHs3F?=
 =?us-ascii?q?H+L3PY1rZ8DoxlQwRkMLkqAssTEnPA22BxWtzUrJixeww5Oye95M2xhMGVrJ?=
 =?us-ascii?q?L+B/jNpg45CQwiEEAxbARCC0lLzxR0CknfCCUeyPkTGIWs3MOCOpRpC23xZd?=
 =?us-ascii?q?zlfurSVoE7uXDPjIunv2So2UAhrsZTLRtF08QTamc29N9qCHp0zJzT/6oela?=
 =?us-ascii?q?GwWqh37Kd02hUnO4+dwlM57ZLf6LiNWuawwC6GE0rUUQVaKPgRqSvx69rkOG?=
 =?us-ascii?q?2HRfDy01BCQLEG1c4VDPZTi+kKjDNdhJ9hLfwq51SKH6D4BbZPgiZcccOUB9?=
 =?us-ascii?q?t8ec6uxY2wPsLKFsjMvv5WW9ySWuYPieP02+e5VF28bX2/q/q2saXpod6vlv?=
 =?us-ascii?q?sxYM3LiJ9sNZwTmwOnz/+JPFp5rXCSAt60t+uPcgplXGFIPE9GoUMfrZabVx?=
 =?us-ascii?q?vZ+wMJjmM3tHs2vwi2qfMjrWr3gHB+b7bxzgBCmDSsKnwEcqVD9Iw0QMrxXW?=
 =?us-ascii?q?tgfeXFhdjLo9ButgYvai1zkpqQ=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3Ak3p+xaEQaGeBM4j1pLqE98eALOsnbusQ8z?=
 =?us-ascii?q?AXPiFKOH9om6Oj+/xG8M506faWslYssQ8b9OxoUZPoKRi3yXcf2+gs1NmZMz?=
 =?us-ascii?q?UPfACTXeRfBUyI+UyDJxHD?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2HdPwBN0Xph/1YnDwpaDw8BKwsGDCK?=
 =?us-ascii?q?DfGGBHwQ8C4Q9jUSDFQOBYIRMQIQ+AgECglOIT4YKgXsBCgEBAQEBAQEBARs?=
 =?us-ascii?q?THAQBAQMDgTKDSCWCMB8JA0cBAgQBARMBAQYBAQEBAQMDBAICgSCFaA2DU4E?=
 =?us-ascii?q?IAQEBAQEBAQEBAQEBAQEBAQEBARYCH1JHAQQEAS0dAQEnARARASICDRkCIzc?=
 =?us-ascii?q?BBxA0AQEkghhHAYINAwmtDxt6gTGBAYIIAQEGglmCOQ2CQAmBEIYng3eFYoE?=
 =?us-ascii?q?QgUgDhVOFPBSCUZIwVJ5ngWyKD5JDaAcogw2ZD4VvLYNZkhWRNqZEkSeEfIE?=
 =?us-ascii?q?KUIFnTXqBFwplXFEXAg+UXIdaAkRoOAIGAQoBAQMJAYI6jhSBEIEQAQ?=
X-IPAS-Result: =?us-ascii?q?A2HdPwBN0Xph/1YnDwpaDw8BKwsGDCKDfGGBHwQ8C4Q9j?=
 =?us-ascii?q?USDFQOBYIRMQIQ+AgECglOIT4YKgXsBCgEBAQEBAQEBARsTHAQBAQMDgTKDS?=
 =?us-ascii?q?CWCMB8JA0cBAgQBARMBAQYBAQEBAQMDBAICgSCFaA2DU4EIAQEBAQEBAQEBA?=
 =?us-ascii?q?QEBAQEBAQEBARYCH1JHAQQEAS0dAQEnARARASICDRkCIzcBBxA0AQEkghhHA?=
 =?us-ascii?q?YINAwmtDxt6gTGBAYIIAQEGglmCOQ2CQAmBEIYng3eFYoEQgUgDhVOFPBSCU?=
 =?us-ascii?q?ZIwVJ5ngWyKD5JDaAcogw2ZD4VvLYNZkhWRNqZEkSeEfIEKUIFnTXqBFwplX?=
 =?us-ascii?q?FEXAg+UXIdaAkRoOAIGAQoBAQMJAYI6jhSBEIEQAQ?=
X-IronPort-AV: E=Sophos;i="5.87,190,1631552400"; 
   d="scan'208";a="12869453"
Received: from zmtap2.jakarta.go.id ([10.15.39.86])
  by mail.jakarta.go.id with ESMTP; 28 Oct 2021 23:42:13 +0700
Received: from localhost (localhost [127.0.0.1])
        by zmtap2.jakarta.go.id (Postfix) with ESMTP id E4846609108E;
        Thu, 28 Oct 2021 23:42:12 +0700 (WIB)
Received: from zmtap2.jakarta.go.id ([127.0.0.1])
        by localhost (zmtap2.jakarta.go.id [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id XTYYwmiX2SaM; Thu, 28 Oct 2021 23:42:12 +0700 (WIB)
Received: from localhost (localhost [127.0.0.1])
        by zmtap2.jakarta.go.id (Postfix) with ESMTP id 794E06278136;
        Thu, 28 Oct 2021 23:42:10 +0700 (WIB)
DKIM-Filter: OpenDKIM Filter v2.10.3 zmtap2.jakarta.go.id 794E06278136
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jakarta.go.id;
        s=zimbra-mail; t=1635439330;
        bh=ket9wQGPBpEx6WIqdSy6e4jzznNT/FBCSFyZOTIJdlo=;
        h=Date:From:Message-ID:MIME-Version;
        b=d0iseZJHqRHVrEZVlDIgVT9z25ma0LcY00S7E6E7dQOYpdPDDyIdY9hGxST0+Vf4+
         SaKLs3SSUjGfm99r8zy4dREyo+5y+FFICPYamJOW9daOkwWp8JqWTTpU4HM/fqGfMq
         dMSraW1pjQ0ZtVvB+I7Fwf/KHF/kq0V+v6NbVmr4zc4Ri/xuA3CXUFvjRFoLZ5cHXe
         KEqS9S1aBzG4+hbGUqoWtRk3m0qA7ZPB0Jvztf5y8M823j+E7Bbrfz12PQt27nEvQB
         OUlqyq7vcYpHCItkUnjI7Hpqmw8azPpzJkNOClIxxN3Jz51RU5BRdwHEtJH/9tXZ4o
         GKWd+NzI22jkw==
X-Virus-Scanned: amavisd-new at 
Received: from zmtap2.jakarta.go.id ([127.0.0.1])
        by localhost (zmtap2.jakarta.go.id [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id dT99UCM36wiy; Thu, 28 Oct 2021 23:42:10 +0700 (WIB)
Received: from zmailbox1.jakarta.go.id (zmailbox1.jakarta.go.id [10.15.39.83])
        by zmtap2.jakarta.go.id (Postfix) with ESMTP id AECD16278113;
        Thu, 28 Oct 2021 23:41:54 +0700 (WIB)
Date:   Thu, 28 Oct 2021 23:41:54 +0700 (WIB)
From:   LAPORTE Marie-Josepha <ses.nakertrans@jakarta.go.id>
Message-ID: <684865653.129757.1635439314635.JavaMail.zimbra@jakarta.go.id>
Subject: =?utf-8?Q?Tr=C3=A8s_Urgent!?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.15.39.86]
X-Mailer: Zimbra 8.8.15_GA_4173 (zclient/8.8.15_GA_4173)
Thread-Index: AsnTuipoXJhS7bnpqOY/7cBeGnnPXQ==
Thread-Topic: =?utf-8?B?VHLDqHM=?= Urgent!
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Bonjour
Je me nomme Mme Marie-Josepha LAPORTE. Je vous adresse ce message plein d=
=E2=80=99amertume et de solitude. Apr=C3=A8s le ravage sauvage de la premi=
=C3=A8re vague li=C3=A9e =C3=A0 la pand=C3=A9mie du coronavirus, j'ai perdu=
 mon mari et ma fille unique. Souffrant moi-m=C3=AAme du cancer du sein en =
phase terminale et sachant que mes jours sont compt=C3=A9s, je vous contact=
e dans le but de vous faire un don d'un montant de deux millions d'euros po=
ur la r=C3=A9alisation des =C5=93uvres de charit=C3=A9.

-Tr=C3=A8s Urgent: Contacter moi a mon l'adresse personnelle et je vous pri=
e de copier mon adresse pour me r=C3=A9pondre : laporte.mariejosepha@gmail.=
com.

Merci
Mme Josepha LAPORTE
