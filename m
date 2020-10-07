Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A9528621B
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Oct 2020 17:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgJGP1E (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Oct 2020 11:27:04 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:48147 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726009AbgJGP1D (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Oct 2020 11:27:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1602084420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=gKwzEO1+YDceNdpI0vvAqi110yN3tPmwnp40Fknr0PA=;
        b=HY5VDo+DY27AXetO4Hy1I2hwcoXRjMNyvhG8Xuw+9GhciBiKvsThAl87NWAnmtHNnLne9U
        hIlG6R3UItfxSNrdKah4Dq0uRDJkSjQO00WMMRYpCJFybC2O7EPH8NSlqOQUM98X8Xkiqw
        yhBpFjn5mrQ7Le9pUdzczimd58RlnOI=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2054.outbound.protection.outlook.com [104.47.5.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-27-hVcQrfBANX2zj5JS9cfk8w-1; Wed, 07 Oct 2020 17:25:40 +0200
X-MC-Unique: hVcQrfBANX2zj5JS9cfk8w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4N4CEwnGUha+o3P6puI1MMxt6L7OEUBuyt/L7fZU7wPTiHDgdWEWrWJwSgUWa4dlsnPpWh39CMhLoO/Q9qWcPsVyz4whg9j59F7noks0vqQ/HzsvqaaA+qztcsFDRg/u6w55n9LsKU87oicsU0NIMVYhkId1V6CLBmysc+ffyVkbeavctgSIB3X00IS8NPByOwK84sSxMtmRHckZb5jUYTrN1MXr5bdYMx8ZqhsTRF85ZNrqgEzOhB+OHTxSzZdpMiNBy8/4dToGpcdJ1cV1SlPM4rGry9dQrPZHbGiV4VxWi8VdTy9TKyJyyOpf+Wkz+1c8F3sM71BmkTmLbrY3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zt8JfxuW0vdX24CssjHtNlb6VYYaOlKUtGIGunBRbv8=;
 b=PEThHWw94pNL3oBHUhLnV+idm5qzg0MzCd8/12SDQyNiXmKrt6npDCAN3HmM7BcJnTa2ldxa0SPkoIp1x3Q3pHjtPSyNFohyYntixre2jtN4Fu2AjVO2QygPQzGKkJOkPUrM5wnNrpU1qU8t2h1UMeMdAwmBsY1aBNKToraYrNXd2qgcWsocB70c8xSzfjF3FaBtQFet5J6FiOfDwjkcDuixq8VW57VeLF1TSYve/4h32kfIDIQHAWtaQDX4GH+cPyMEWTNZNat3hXI4q3nijT+MOU3OihJOxD2dtQ3nv+4NgExsuQvTFpeZD47qIkOfR3uFY9hPUE4kvsWwY1HYOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR0402MB3570.eurprd04.prod.outlook.com
 (2603:10a6:208:1c::11) by AM0PR04MB6770.eurprd04.prod.outlook.com
 (2603:10a6:208:187::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Wed, 7 Oct
 2020 15:25:39 +0000
Received: from AM0PR0402MB3570.eurprd04.prod.outlook.com
 ([fe80::b0d3:41fb:9189:99be]) by AM0PR0402MB3570.eurprd04.prod.outlook.com
 ([fe80::b0d3:41fb:9189:99be%7]) with mapi id 15.20.3455.023; Wed, 7 Oct 2020
 15:25:39 +0000
To:     Travis Nielsen <tnielsen@redhat.com>,
        Sebastian Wagner <swagner@suse.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Varsha Rao <varao@redhat.com>, Sebastien Han <seb@redhat.com>,
        Ceph Development List <ceph-devel@vger.kernel.org>
References: <CAByD1q-w83TQgCof5TJH0DWXPMobbqQQcbuaKsnE6PqNsaWqVw@mail.gmail.com>
From:   Denis Kondratenko <denis.kondratenko@suse.com>
Autocrypt: addr=denis.kondratenko@suse.com; prefer-encrypt=mutual; keydata=
 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
Subject: Re: Rook orchestrator module
Message-ID: <85e76f2e-660f-e4ba-2c5f-623ad98c4d2b@suse.com>
Date:   Wed, 7 Oct 2020 17:25:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <CAByD1q-w83TQgCof5TJH0DWXPMobbqQQcbuaKsnE6PqNsaWqVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2001:67c:2178:4000::1111]
X-ClientProxiedBy: AM4PR05CA0033.eurprd05.prod.outlook.com (2603:10a6:205::46)
 To AM0PR0402MB3570.eurprd04.prod.outlook.com (2603:10a6:208:1c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:113:80c0:8080:10:160:68:83] (2001:67c:2178:4000::1111) by AM4PR05CA0033.eurprd05.prod.outlook.com (2603:10a6:205::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Wed, 7 Oct 2020 15:25:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a42e51f-c274-400e-fd56-08d86ad53ef9
X-MS-TrafficTypeDiagnostic: AM0PR04MB6770:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6770D0DAF0994AB1A862C9F5980A0@AM0PR04MB6770.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wkVCrbl0gr0hjXv3xiscwsmClfz+YQ8VyPlZvLFd1RD6sUxiAffj3ztmfEyJkzMpiHvG46WZkP+iSxa3rx2G7VoGHwfs2T4+csEUuzaD5uoxKS/xcHICYrNc/xCPpluKMJ5J8JfyQmzUHYL0tuscZMBRrwQc4w/iilLVntcLQcNQ9sVf6p6w2Oxa8yYIgUdcdPs+dBC6k/5WzdUt+89Io+u5ZiGojSDuCw4echrKJlW8EqhSmfATvNOkhBYd4o+xZj6HDpN2wKOo46VOwHBsd5z1sEiEvqGp6HOMecOo/2nxSWtE00Kr15uGMYn98Dnlvsnnecm44mEatX4acjxnMrtiepR+sEBwO3HPnJoTkmUbiwBRhRNYTz+bAZRrtW2o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3570.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(396003)(136003)(86362001)(31696002)(316002)(83380400001)(52116002)(110136005)(2906002)(7116003)(44832011)(31686004)(66574015)(66476007)(66556008)(66946007)(3480700007)(2616005)(478600001)(53546011)(6486002)(5660300002)(186003)(16526019)(8936002)(36756003)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: doV63cMAtjcAi3icUBTVwWFvBH8zmoQ23lifm3VIFpXD5QXB/V1aXgvWRbEMiNRKSYBierYuB3M6hSNkDQ2mfMS/IwyzLpZz9AKCBOlBlF7K71iAG4oHsVVfKoACo5iGXydsFNIR5tOs8nmTXfT40xM2hir5zaefuc2KJs32HK3XM9xSd4IVWMgHUy3nna4e+CqHx3U37opXuvVlGZovirMqNyeJRbrw59+X/6ziRwxr2nh/AW1O9Rh1vtUpxEqWVwQNw6h57cnb/mBEs+PVv+kTITnDJxYYeWoTO84BlaB90hyW4ukRSh+8yed4TvBGDDjjSXbbsZ78K9ygp3VoUzmDaYp/F+JtUTc+8RM8mS6tGK7ZtEksRLkncV9ma0xdkenxaT/4YENeO1B7FvlS+o0R24tf9tRYLurwbxCZR7Aazst/epnAp7vJasglfyyidtMD/5raK+n5gQ6S5MuVqkjx4MbxeGmntpxDY1FKf1VweJiCnGrXN6a35mHdCA54p0ILFvftjclXNBmuqYqu4SczF+mqOflt0ExTTCFnHnvfxDRKUpfLZFrSNT+fHvOohgqFhnWWhr/DA2yWmwbOqppqL5gIr2pbNJrJRBfQZLsLXZWkwJHnnvuAgZDBUvuX3qAN7clv/P48D0ZBZyQjSc62UDdxv79pQFNxvUi+TNw=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a42e51f-c274-400e-fd56-08d86ad53ef9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0402MB3570.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 15:25:39.4541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fz7pKIk44/kYPoR3oqBX1DVU3BmEkeKB4y/0KQHkBTnf5t4sWEUwoDwCVPVj7CUws47k/Eo3yf+2Miyx6SkUahJywzTpHssKi7AbG0Z8gqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6770
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 9/29/20 9:31 PM, Travis Nielsen wrote:

> The purpose of the orchestrator module was originally to provide a
> common entry point either for Ceph CLI tools or the dashboard. This
> would provide the constant interface to work with both Rook or cephadm
> clusters. Patrick pointed out that the dashboard isn=E2=80=99t really a
> scenario anymore for the orchestrator module. If so, the only
> remaining usage is for CLI tools. And if we only have the CLI
> scenario, this means that the CLI commands would be run from the
> toolbox. But we are trying to avoid the toolbox. We should be putting
> our effort into the CRDs, CSI driver, etc.

I though it is exactly that, providing CLI to change something with the
same unified (cephadm and Rook) orch interface. Like checking what
resources are available, adding daemons, modifying DriveGroups, updating
Ceph version and discovering that there are new updates in the registry.

Sure node management probably is better on k8s level, and yes many of
those tasks ppl could do modifying CRs and applying them.
But it might be that Ceph admin would be inside toolbox to watch cluster
state, fixing it and modifying things for a quite some time.

So it (as idea) make sense for Ceph specific actions (services, drive
configs, osd configs, troubleshoot, Ceph versions) to use Ceph CLI.
And for k8s specific actions (labels, nodes, toleration, CRs creation
and etc) to use k8s CLI.

But that is more dev/eng point of view, don't know if that correlates to
much with user experience.

>=20
> If the orchestrator module is creating CRs, we are likely doing
> something wrong. We expect the cluster admin to create CRs.

I would echo that. But changing CR for "cephVersion" looks like a good idea=
.

BTW how update workflow of cephVersion is designed? There is no Helm
chart (and that looks logical) and there is no other way to changed but
edit the CR directly or by applying some manual changes in some self
managed "yaml" file.
In case of user, maybe I would like to control that mostly myself. But
as vendor, vendor would like to control Ceph version, to limit user to
supported images.

>=20
> Thus, I=E2=80=99d like to understand the scenarios where the rook orchest=
rator
> module is needed. If there isn=E2=80=99t a need anymore since dashboard
> requirements have changed, I=E2=80=99d propose the module can be removed.

Maybe, but that also the question to the end user. cephadm is not widely
adopted and there is not much feedback if extended orch is useful and it
might be better unified with Rook.

Also many devs are busy with cephadm so not much time to extend orch for
Rook.

>=20
> Thanks,
> Travis
> Rook
>=20

Thanks,
--=20
Denis Kondratenko
Engineering Manager SUSE Linux Enterprise Storage

SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 Nuremberg
Germany

(HRB 36809, AG N=C3=BCrnberg)
Managing Director: Felix Imend=C3=B6rffer

